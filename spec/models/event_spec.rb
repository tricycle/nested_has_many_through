require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../app'

describe Event do

  describe "> invitations" do

    before do
      @event = Event.create!(:name => 'Barcamp')
      @janick = Invitee.create!(:name => 'Janick Gers')
      @dave = Invitee.create!(:name => 'Dave Murray')
      @invitation = @event.invitations.create!(:invitee => @janick)
      @event.reload
    end

    it "should be able to create" do
      @event.invitations.should have(1).record
      @event.invitations.first.should == @invitation
      @event.invitations.first.invitee.should == @janick
    end

    it "should be able to delete" do
      @event.invitations.delete(@invitation)
      @event.reload
      @event.invitations.should have(0).records
    end

    it "should be able to <<" do
      @event.invitations << new_invitation = Invitation.create!(:invitee => @janick)
      @event.reload
      @event.should have(2).invitations
      @event.invitations.should include(new_invitation)
    end
    
    it "should be able to find invitations" do
      @event.invitations.should include(@invitation)
    end

    describe " > invitees" do
      it "should be able to create" do
        @steve = @event.invitees.create!(:name => 'Steve Harris')
        @event.reload
        @event.should have(2).invitees
        @event.invitees.should include(@steve)
      end

      it "should be able to delete" do
        @event.invitees.delete(@janick)
        @event.reload
        @event.invitees.should have(0).records
        @event.invitees.should_not include(@janick)
      end

      it "should be able to <<" do
        @event.invitees << @dave
        @event.reload
        @event.should have(2).invitations
        @event.invitees.should include(@dave)
      end

      it "should be able to find invitees" do
        @event.invitees.should include(@janick)
      end
    end

    describe "> attendees" do
      before do
        @nicko = Invitee.create!(:name => "Nicko Mc'Brain")
        @event.invitations.create!(:invitee => @nicko, :attending => true)
        @event.reload
      end

      it "should be able to create" do
        pending("The create as such is not a problem, just that it will again be inserted as invitee, since create is not scoped. Have to enable callbacks to make this work.")
        @bruce = @event.attendees.create!(:name => 'Bruce Dickinson')
        @event.reload
        @event.attendees.should include(@bruce)
        @event.invitees.should include(@bruce)
        @event.should have(3).invitees
        @event.should have(2).attendees
        #at least one attending should be true
        eval(@event.invitations.collect(&:attending).join(" || ")).should == true
      end

      it "should be able to delete" do
        @event.attendees.delete(@nicko)
        @event.reload
        @event.attendees.should have(0).records
        @event.invitees.should have(1).records
        @event.invitees.should_not include(@nicko)
      end

      it "should be able to <<" do
        pending("The insert as such is not a problem, just that it will again be inserted as invitee, since create is not scoped. Have to enable callbacks to make this work.")
        @event.attendees << @dave
        @event.reload
        @event.should have(2).attendees
        @event.attendees.should include(@dave)
      end

      it "should be able to find invitations" do
        @event.attendees.should include(@nicko)
        @event.invitees.should include(@nicko)
      end
    end
  end
end
