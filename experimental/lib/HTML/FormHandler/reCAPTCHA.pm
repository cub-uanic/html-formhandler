package HTML::FormHandler::reCAPTCHA;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
our $VERSION = '0.01';

has 'pub_key'  => ( is => 'ro', isa => 'Str', required => 1 );
has 'priv_key' => ( is => 'ro', isa => 'Str', required => 1 );
has 'request_address' => ( is => 'rw', isa => 'Str' );

# we need flatten arguments, because arguments which came from
# Catalyst::Model::Adaptor will be passed as one hashref,
# but we need flatten hash
around BUILDARGS => sub {
   my $orig  = shift;
   my $class = shift;

   if ( @_ == 1 && ref( $_[0] ) eq 'HASH' ) {
      return $class->$orig( %{ $_[0] } );
   }
   else {
      return $class->$orig(@_);
   }
};

__PACKAGE__->meta->make_immutable;

=head1 AUTHOR

Oleg Kostyuk, cub.uanic@gmail.com

=head1 LICENSE

(c) 2009 Aibu IT & Design Services

=head1 COPYRIGHT

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;

