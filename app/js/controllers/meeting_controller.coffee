'use strict'

angular.module 'tandemApp'

.controller 'MeetingController',
($scope, Meeting, Attendee, inform, SweetAlert) ->
  $scope.meeting = {}
  $scope.meeting.attendees = []
  $scope.meeting.schedule =
    days:
      monday:
        day_code: 'M',
        morning: 'available',
        afternoon: 'available',
        evening: 'unavailable'
      tuesday:
        day_code: 'T',
        morning: 'available',
        afternoon: 'unavailable',
        evening: 'unavailable'
      wednesday:
        day_code: 'W',
        morning: 'available',
        afternoon: 'available',
        evening: 'unavailable'
      thursday:
        day_code: 'Th',
        morning: 'unavailable',
        afternoon: 'available',
        evening: 'unavailable'
      friday:
        day_code: 'F',
        morning: 'available',
        afternoon: 'available',
        evening: 'available'

  Meeting.addMeeting().$promise.then (meeting) ->
    $scope.meeting.id = meeting._id

  $scope.addAttendee = ->
    if $scope.newEmail
      email =
        meeting_id: $scope.meeting.id,
        email: $scope.newEmail

      Attendee.addAttendee(email).$promise.then (attendee) ->
        #$scope.meeting.attendees.push attendee
        $scope.meeting.attendees.push email
        $scope.newEmail = ''
        inform.add("Added "+email.email, { type: "success" })
      .catch ->
        # TODO: Add failure alert
        inform.add("Unable to add email address", {type: "danger"})

  $scope.deleteAttendee = (index) ->
    SweetAlert.swal {
      title: "Are you sure?"
      text: "This will remove this person from your meeting"
      type: "warning"
      showCancelButton: true
      confirmButtonColor: "rgba(217, 83, 79, 0.7)"
      confirmButtonText: "Remove "+$scope.meeting.attendees[index].email
      closeOnConfirm: true
    }, (confirm)->
      if confirm
        delObject =
          meeting_id: $scope.meeting.id
          email: $scope.meeting.attendees[index].email

        Attendee.deleteAttendee(delObject).$promise.then ->
          inform.add("Removed "+delObject.email, { type: "success" })
          $scope.meeting.attendees.splice(index, 1)
        .catch ->
          console.log 'err'
          inform.add("Unable to remove email address", {type: "danger"})

  $scope.populateCalendar = ->


