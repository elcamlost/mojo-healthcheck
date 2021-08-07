requires "Mojolicious" => "9";
requires "perl" => "5.020";
requires "HealthCheck" => "0";

on 'test' => sub {
  requires "Test2::MojoX" => "0";
};

