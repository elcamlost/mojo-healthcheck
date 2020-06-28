package TestMojoApp;
use Mojolicious::Lite;

plugin('HealthCheck');

get '/' => 'index';

app->start;


__DATA__

@@ index.html.ep
HealthCheck Test index
