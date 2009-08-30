package HTML::FormHandler::Field::reCAPTCHA;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Field';
use Captcha::reCAPTCHA;
our $VERSION = '0.01';

has '+widget' => ( default => 'from_field', );

sub BUILD
{
   my $self = shift;

   die('reCAPTCHA filed should be named as recaptcha_response_field')
      unless $self->name eq 'recaptcha_response_field';
}

sub render
{
   my $self = shift;

   return Captcha::reCAPTCHA->new->get_html( $self->form->pub_key );
}

sub validate
{
   my $self = shift;

   my $challenge = $self->form->get_param('recaptcha_challenge_field');
   my $response  = $self->form->get_param('recaptcha_response_field');

   return $self->add_error('user appears not to have submitted a recaptcha')
      unless ( $response && $challenge );

   my $result = Captcha::reCAPTCHA->new->check_answer(    # perltidy hack
      $self->form->priv_key,
      $self->form->request_address,
      $challenge,
      $response,
   );

   return $self->add_error('failed to get valid result from reCAPTCHA')
      unless $result;

   return $self->add_error( $result->{error} || 'reCAPTCHA: unknown error' )
      unless $result->{is_valid};

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

