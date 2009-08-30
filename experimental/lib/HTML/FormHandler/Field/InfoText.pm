package HTML::FormHandler::Field::InfoText;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Field::Text';
our $VERSION = '0.01';

has '+widget' => ( default => 'from_field', );

sub render
{
   my ($self) = @_;

   my $output;
   $output .= $self->label ? $self->label . ': ' : '';
   $output .= $self->fif;

   $output .= '<input type="hidden" name="';
   $output .= $self->html_name . '"';
   $output .= ' id="' . $self->id . '"';
   $output .= ' value="' . $self->fif . '" />';

   return $output;
}

sub validate
{
   return 1;
}

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

