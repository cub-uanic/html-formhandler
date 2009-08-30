package HTML::FormHandler::Field::Upload;

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::AttributeHelpers;
use Carp 'croak';
use List::MoreUtils 'any';

extends 'HTML::FormHandler::Field';

our $VERSION = '0.01';

=head1 NAME

HTML::FormHandler::Field::Upload - File upload field
(mostly based on original HTML::FormHandler::Field::File)

=head1 DESCRIPTION

Validates that the input is an uploaded file.

=head1 DEPENDENCIES

=head2 widget

Widget type is 'file'

=cut

has '+widget' => ( default => 'from_field', );
has minimum   => ( is      => 'rw', isa => 'Int', default => 1 );
has maximum   => ( is      => 'rw', isa => 'Int', default => 1_048_576 );

sub BUILD
{
   for my $form ( $_[0]->form ) {
      $form->enctype('multipart/form-data');
      $form->http_method('post');
   }
}

sub minimum_kilobyte
{
   croak "minimum_kilobyte() cannot be used as a getter"
      if @_ < 2;

   return $_[0]->minimum( $_[1] << 10 );
}

sub minimum_megabyte
{
   croak "minimum_megabyte() cannot be used as a getter"
      if @_ < 2;

   return $_[0]->minimum( $_[1] << 20 );
}

sub maximum_kilobyte
{
   croak "maximum_kilobyte() cannot be used as a getter"
      if @_ < 2;

   return $_[0]->maximum( $_[1] << 10 );
}

sub maximum_megabyte
{
   croak "maximum_megabyte() cannot be used as a getter"
      if @_ < 2;

   return $_[0]->maximum( $_[1] << 20 );
}

sub validate
{
   my $self   = shift;
   my $upload = $self->upload();

   blessed $upload and
      $upload->size > 0 or
      return $self->add_error('This is not valid file upload data');

   my $size = $upload->size;

   $size >= $self->minimum or
      return $self->add_error( 'File is too small (< [_1] bytes)', $self->minimum );

   $size <= $self->maximum or
      return $self->add_error( 'File is too big (> [_1] bytes)', $self->maximum );

   return $upload;
}

sub upload
{
   my $self = shift;

   return $self->form->ctx->req->upload( $self->name );
}

sub render
{
   my $self = shift;

   my $output;
   $output .= $self->label ? $self->label . ': ' : '';
   $output = '<input type="file" name="';
   $output .= $self->html_name . '"';
   $output .= ' id="' . $self->id . '"/>';
   return $output;
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

