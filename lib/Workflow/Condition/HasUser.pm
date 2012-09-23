package Workflow::Condition::HasUser;

# $Id: HasUser.pm 454 2009-01-12 10:04:02Z jonasbn $

use warnings;
use strict;
use base qw( Workflow::Condition );
use Log::Log4perl qw( get_logger );
use Workflow::Exception qw( condition_error );

$Workflow::Condition::HasUser::VERSION = '1.05';

my $DEFAULT_USER_KEY = 'current_user';

sub _init {
    my ( $self, $params ) = @_;
    my $key_name = $params->{user_key} || $DEFAULT_USER_KEY;
    $self->param( user_key => $key_name );
}

sub evaluate {
    my ( $self, $wf ) = @_;
    my $log = get_logger();
    $log->is_debug
        && $log->debug( "Trying to execute condition ", ref $self );
    my $user_key     = $self->param('user_key');
    my $current_user = $wf->context->param($user_key);
    $log->debug( "Current user in the context is '$current_user' retrieved ",
        "using parameter key '$user_key'" );
    unless ($current_user) {
        condition_error
            "No current user available in workflow context key '$user_key'";
    }
}

1;

__END__

=head1 NAME

Workflow::Condition::HasUser - Condition to determine if a user is available

=head1 VERSION

This documentation describes version 1.05 of this package

=head1 SYNOPSIS

 # First setup the condition
 
 <conditions>
   <condition name="HasUser"
              class="Workflow::Condition::HasUser">
     <param name="user_key" value="CurrentUser" />
   </condition>
   ...

 # Next, attach it to an action
 
 <state name="INITIAL">
   <action name="create issue"
           resulting_state="CREATED">
       <condition name="CurrentUser" />
   </action>
   ...

 # Whenever you fetch available actions from state 'INITIAL' you must
 # have the key 'CurrentUser' defined in the workflow context

=head1 DESCRIPTION

Simple -- possibly too simple -- condition to determine if a user
exists in a particular context key. Actually, it really only
determines if B<something> exists in a key, but we needed a simple
condition to ship with the module.

=head2 Parameters

You can configure the condition with the following parameters:

=over 4

=item *

B<user_key>, optional

Key in workflow context to check for data. If not specified we use
'current_user'.

=back

=head2 METHODS

=head3 evaluate ( $wf )

Method to evaluate whether a user has been set for a workflow.

Takes a workflow object as parameter

Throws L<Workflow::Exception> if evaluation fails

=head1 SEE ALSO

L<Workflow::Condition>

=head1 COPYRIGHT

Copyright (c) 2004 Chris Winters. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS

Chris Winters E<lt>chris@cwinters.comE<gt>
