'use strict';

function datepickerBase(scope, timeout) {
	scope.today = function() {
		scope.dt = new Date();
	};
	scope.today();

	scope.showWeeks = true;
	scope.toggleWeeks = function() {
		scope.showWeeks = !scope.showWeeks;
	};

	scope.clear = function() {
		scope.dt = null;
	};
	
	scope.current = new Date();

	// Disable weekend selection
	scope.disabled = function(date, mode) {
		return false;// ( mode === 'day' && ( date.getDay() === 0 ||
		// date.getDay() === 6 ) );
	};

	scope.toggleMin = function() {
		scope.minDate = (scope.minDate) ? null : new Date();
	};
	scope.toggleMin();

	scope.open = function() {
		timeout(function() {
			scope.opened = true;
		});
	};

	scope.dateOptions = {
		'year-format' : "'yy'",
		'starting-day' : 1
	};
}

function DatepickerCtrl($scope, $timeout) {
	datepickerBase($scope, $timeout);

	$scope.current = new Date();
	
	$scope.$watch('dt', function() {
		$scope.$emit('dateSelected', $scope.dt);
	});
}