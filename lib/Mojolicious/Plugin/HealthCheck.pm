package Mojolicious::Plugin::HealthCheck;
use Mojo::Base 'Mojolicious::Plugin';
use experimental qw/signatures/;

our $VERSION = '0.01';

use HealthCheck;
use Mojo::Util qw//;

sub register ($, $app, $conf) {

    state $h = HealthCheck->new(
        id     => $conf->{id} // Mojo::Util::decamelize($app->moniker),
        tags   => ['default'],
        checks => [sub { +{status => 'OK'} },],
    );
    $app->helper('health_check' => sub {$h});

    my $prefix = $conf->{route} || $app->routes->any('/healthz');
    $prefix->get('/' => \&_render_checks)->name('health_check');
}

sub _render_checks ($c) {
    my $results = $c->health_check->check(tags => $c->every_param('tags'));
    my $code    = (($results->{status} // '') eq 'OK') ? 200 : 503;
    return $c->render(json => $results, status => $code,);
}

1;
