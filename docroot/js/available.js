'use strict';

function loadAvailableReservations(scope, api, timeout) {

	scope.available = [];
	scope.loading = true;
	scope.slotSelected = false;
	scope.slot = null;

	api.getAvailableReservations(scope.experimentSelected,
			[ scope.telescopeSelected ], scope.dt, function(data) {
				var slots = [];
				data.forEach(function(element) {
					slots.push({
						begin : element.begin,
						end : element.end,
					});
				});

				scope.available = slots;
				scope.npages = Math.ceil(slots.length / scope.slotsPerPage);

				if (scope.table != undefined) {
					scope.table.set('recordset', scope.available.slice(0,
							scope.slotsPerPage));
					scope.pagination.set('total', scope.npages);
					/*scope.timer = timeout(function() {
						document.getElementById('timeslotTitle')
								.scrollIntoView(false);

					}, 100, 0);*/
				}

				scope.loading = false;

			}, function(data, status) {
				console.log('error', data, status);
				scope.loading = false;
			});
}

function pad(n) {
	return (n < 10) ? ("0" + n) : n;
}

function buildUIAvTable(scope, elementName, paginationName) {
	YUI()
			.use(
					'aui-datatable',
					'aui-pagination',
					function(Y) {

						scope.table = new Y.DataTable({
							// boundingBox : '#table',
							columns : [ {
								key : 'begin',
								label : 'Begin',
								sortable : 'true',
								formatter : function(o) {
									o.rowClass = 'rowBack';

									var date = new Date(o.value);

									var dateStr = '' + pad(date.getHours());
									dateStr += ':' + pad(date.getMinutes());
																		
									dateStr += ' (' + pad(date.getUTCHours());
									dateStr += ':' + pad(date.getUTCMinutes());
									dateStr += ' UT)';
									
									o.value = dateStr;
								}

							}, {
								key : 'end',
								label : 'End',
								sortable : 'true',
								formatter : function(o) {
									o.rowClass = 'rowBack';
									var date = new Date(o.value);

									var dateStr = '' + pad(date.getHours());
									dateStr += ':' + pad(date.getMinutes());
																		
									dateStr += ' (' + pad(date.getUTCHours());
									dateStr += ':' + pad(date.getUTCMinutes());
									dateStr += ' UT)';
									
									
									o.value = dateStr;
								}

							} ],
							recordset : scope.available.slice(0,
									scope.slotsPerPage)
						});

						scope.table.delegate('click', function(e) {
							var target = e.currentTarget;
							var record = this.getRecord(target).toJSON();

							if (record != null) {
								if (record.begin != null
										&& record.begin != undefined) {
									scope.slotSelected = true;
									scope.slot = record;
									scope.reservationDone = false;
									scope.reservationError = false;
									scope.$apply();
								}
							}

						}, 'tr', scope.table);

						scope.table.render('#table');

						scope.pagination = new Y.Pagination(
								{
									contentBox : '#pagination aui-pagination-content',
									page : 1,
									total : scope.npages,
									on : {
										changeRequest : function(event) {

											if (event.state.page <= scope.npages) {

												var fromIndex = ((event.state.page - 1) * scope.slotsPerPage);
												var toIndex = ((event.state.page - 1) * scope.slotsPerPage)
														+ scope.slotsPerPage;

												scope.table.set('recordset',
														scope.available.slice(
																fromIndex,
																toIndex));
											}
										}
									}
								});

						scope.pagination.render('#pagination');
					});
}

function AvailableReservationsListCtrl(GloriaAPI, $scope, $timeout) {

	$scope.available = [];
	$scope.slotsPerPage = 10;
	$scope.slotSelected = false;
	$scope.dateSelected = false;
	$scope.reservationDone = false;
	$scope.reservationError = false;

	$scope.dt = null;
	
	$scope.$watch('password', function () {

		GloriaAPI.setCredentials($scope.user, $scope.password);
		buildUIAvTable($scope, 'table', 'pagination');
	});

	

	$scope.$on('dateSelected', function(date) {
		if ($scope.telescopeSelected) {
			$scope.dt = date.targetScope.dt;
			$scope.slotSelected = false;
			$scope.dateSelected = true;
			$scope.reservationDone = false;
			$scope.reservationError = false;
			loadAvailableReservations($scope, GloriaAPI, $timeout);
		}
	});

	$scope.reserve = function() {
		GloriaAPI.makeReservation($scope.experimentSelected,
				[ $scope.telescopeSelected ], $scope.slot.begin,
				$scope.slot.end, function(data) {
					loadAvailableReservations($scope, GloriaAPI);
					$scope.reservationDone = true;

				}, function(data) {
					console.log('error', data);
					$scope.reservationError = true;
					$scope.loading = false;
				});
	};

	$scope.back = function() {
		$scope.dateSelected = false;
		$scope.slotSelected = false;
	};

	$scope.experimentClicked = function(experiment) {
		$scope.experimentSelected = experiment;
		$scope.telescopeSelected = null;
		$scope.slotSelected = false;
		$scope.available = [];
		$scope.dateSelected = false;
		$scope.reservationDone = false;
		$scope.reservationError = false;
	};

	$scope.telescopeClicked = function(rt) {
		$scope.telescopeSelected = rt;
		$scope.slotSelected = false;
		$scope.dateSelected = false;
		$scope.reservationDone = false;
		$scope.reservationError = false;
		// loadAvailableReservations($scope, GloriaAPI);
	};
}
