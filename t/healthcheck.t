use Test2::MojoX;
use Test2::V0 -target => 'Mojolicious::Plugin::HealthCheck';

use Mojo::Base -strict, -signatures;
use Mojolicious::Routes::Route;

use FindBin;
use lib "$FindBin::Bin/lib";

subtest 'default' => sub {
    my $t = Test2::MojoX->new('TestMojoApp');

    $t->get_ok('/')->status_is(200)->content_is("HealthCheck Test index\n");

    $t->get_ok('/healthz')->status_is(200, 'default path set up correctly')->json_is(
        '',
        hash {
            field id     => 'test_mojo_app';
            field status => 'OK';
            field tags   => [qw/default/];
        },
        'default response'
    );

    $t->get_ok('/healthz?tags=')->status_is(503, 'empty tags leads to error')->json_like(
        '',
        hash {
            field id      => 'test_mojo_app';
            field status  => 'UNKNOWN';
            field results => array {};
            field tags    => [qw/default/];
        },
        'tags= response'
    );
};

done_testing();
