require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../app'

describe "without any explicit reloads", Event do

  describe "> invitations" do

    before do
      @event = Event.create!(:name => 'Barcamp')
      @janick = Invitee.create!(:name => 'Janick Gers')
      @dave = Invitee.create!(:name => 'Dave Murray')
      @invitation = @event.invitations.create!(:invitee => @janick)
    end

    it "should be able to create" do
      @event.invitations.should have(1).record
      @event.invitations.first.should == @invitation
      @event.invitations.first.invitee.should == @janick
    end

    it "should be able to delete" do
      @event.invitations.delete(@invitation)
      @event.invitations.should have(0).records
    end

    it "should be able to <<" do
      @event.invitations << new_invitation = Invitation.create!(:invitee => @janick)
      @event.should have(2).invitations
      @event.invitations.should include(new_invitation)
    end
    
    it "should be able to find invitations" do
      @event.invitations.should include(@invitation)
    end

    describe " > invitees" do
      it "should be able to create" do
        @steve = @event.invitees.create!(:name => 'Steve Harris')
        @event.should have(2).invitees
        @event.invitees.should include(@steve)
      end

      it "should be able to delete" do
        @event.invitees.delete(@janick)
        @event.invitees.should have(0).records
        @event.invitees.should_not include(@janick)
      end

      it "should be able to <<" do
        @event.invitees << @dave
        @event.should have(2).invitations
        @event.invitees.should include(@dave)
      end

      it "should be able to find invitees" do
        @event.invitees.should include(@janick)
      end

      describe "> tribes" do
        before do
          @adrain = @event.invitees.create!(:name => "Adrain Smith", :tribe => Tribe.create!(:name => "Clansman's tribe"))
          @clansmans_tribe = @adrain.tribe
        end

        it "should be able to create" do
          @atlantis = @event.tribes.create!(:name => 'Atlantis')
          @event.should have(2).tribes
          @event.tribes.should include(@atlantis)
        end

        it "should be able to delete" do
          @event.tribes.delete(@clansmans_tribe)
          @event.tribes.should have(0).records
          @event.invitees.should_not include(@adrain)
        end

        it "should be able to <<" do
          @guitaring_tribe = Tribe.create!(:name => 'Superb guitarists')
          @event.tribes << @guitaring_tribe
          @event.should have(2).tribes
          @event.tribes.should include(@guitaring_tribe)
        end

        it "should be able to find invitees" do
          @event.tribes.should include(@clansmans_tribe)
        end
      end
    end

    describe "> attendees" do
      before do
        @nicko = Invitee.create!(:name => "Nicko Mc'Brain")
        @event.invitations.create!(:invitee => @nicko, :attending => true)
      end

      it "should be able to create" do
        @bruce = @event.attendees.create!(:name => 'Bruce Dickinson')
        @event.attendees.should include(@bruce)
        @event.invitees.should include(@bruce)
        @event.should have(3).invitees
        @event.should have(2).attendees
        #at least one attending should be true
        eval(@event.invitations.collect(&:attending).compact.join(" || ")).should == true
      end

      it "should be able to delete" do
        @event.attendees.delete(@nicko)
        @event.attendees.should have(0).records
        @event.invitees.should have(1).records
        @event.invitees.should_not include(@nicko)
      end

      it "should be able to <<" do
        @event.attendees << @dave
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
