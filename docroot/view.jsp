
<%
	/**
	 * Copyright (c) 2000-2011 Liferay, Inc. All rights reserved.
	 *
	 * This library is free software; you can redistribute it and/or modify it under
	 * the terms of the GNU Lesser General Public License as published by the Free
	 * Software Foundation; either version 2.1 of the License, or (at your option)
	 * any later version.
	 *
	 * This library is distributed in the hope that it will be useful, but WITHOUT
	 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
	 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
	 * details.
	 */
%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>

<portlet:defineObjects />

<%@ page import="com.liferay.portal.theme.ThemeDisplay"%>
<%@ page import="com.liferay.portal.kernel.util.WebKeys"%>
<%@ page import="com.liferay.portal.model.User"%>

<script src="http://cdn.alloyui.com/2.0.0/aui/aui-min.js"></script>

<link href="http://cdn.alloyui.com/2.0.0/aui-css/css/bootstrap.min.css" rel="stylesheet"></link>

<link href="<%=request.getContextPath()%>/css/custom.css"
	rel="stylesheet"></link>

<script
	src=https://ajax.googleapis.com/ajax/libs/angularjs/1.2.1/angular.min.js></script>
<script src="http://code.angularjs.org/1.2.1/angular-animate.min.js"></script>
<script src=http://code.angularjs.org/1.2.1/angular-route.js></script>
<script src="http://cdn.alloyui.com/2.0.0/aui/aui-min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.5.0/ui-bootstrap-tpls.min.js"></script>



<script src="<%=request.getContextPath()%>/js/gloriapi.js"></script>
<script src="<%=request.getContextPath()%>/js/app.js"></script>
<script src="<%=request.getContextPath()%>/js/datepicker.js"></script>
<script src="<%=request.getContextPath()%>/js/available.js"></script>


<%
	ThemeDisplay themeDisplay = (ThemeDisplay) request
			.getAttribute(WebKeys.THEME_DISPLAY);
	User user = themeDisplay.getUser();
%>


<div ng-app="toolbox" ng-controller="AvailableReservationsListCtrl" style="color: silver">
	<div ng-init="user='<%= user.getEmailAddress() %>';password='<%= user.getPassword() %>'">
	</div>
	<h3>Make your reservation</h3>
	<hr class="divider">
	<div class="container">
		<div class="container">
			<div style="text-align: center; float: left; width: 30%;">
				<h4>1. Select an experiment</h4>
				<ul class="thumbnails">
					<li style="float: none;">
						<div class="thumbnail tilt pcard"
							style="background-image: url('<%= request.getContextPath()%>/img/sun.jpg'); width: 70%; height: 100px;"
							ng-click="experimentClicked('SOLAR')"
							ng-class="{highCard: experimentSelected == 'SOLAR'}">
							<h5>"SOLAR"</h5>
							<p>
								<i>Explore the Sun</i>
							</p>
						</div>
					</li>
					<li style="float: none;">
						<div class="thumbnail tilt pcard"
							ng-click="experimentClicked('NIGHT')"
							ng-class="{highCard: experimentSelected == 'NIGHT'}"
							style="width: 70%; height: 100px; background-image: url(https://scontent-b.xx.fbcdn.net/hphotos-prn2/1393169_10152085662121869_26816648_n.jpg);">
							<h5>"NIGHT"</h5>
							<p>
								<i>Explore the Night Sky</i>
							</p>
						</div>
					</li>
				</ul>
			</div>

			<div ng-show="experimentSelected != null" class="animate-show"
				style="text-align: center; float: left; width: 30%;">
				<h4>2. Select a telescope</h4>
				<ul class="thumbnails">
					<li class="animate-show" style="float: none;"
						ng-show="experimentSelected == 'SOLAR'">
						<div class="thumbnail tilt pcard"
							style="height: 100px; background-image: url(http://gloria-project.eu/wp-content/uploads/2013/11/t13.jpg); width: 70%;"
							ng-click="telescopeClicked('TAD')"
							ng-class="{highCard: telescopeSelected == 'TAD'}">
							<h5>"TAD"</h5>
							<p>
								<i>Tenerife, Spain</i>
							</p>
						</div>
					</li>
					<li class="animate-show" style="float: none;"
						ng-show="experimentSelected == 'NIGHT'">
						<div class="thumbnail tilt pcard"
							style="height: 100px; background-image: url(http://gloria-project.eu/wp-content/uploads/2012/05/T07-BART.png); width: 70%;"
							ng-click="telescopeClicked('BART')"
							ng-class="{highCard: telescopeSelected == 'BART'}">
							<h5>"BART"</h5>
							<p>
								<i>Ondrejov, Czech Republic</i>
							</p>
						</div>
					</li>
				</ul>
			</div>

			<div class="animate-show"
				style="text-align: center; float: left; width: 40%;"
				ng-show="experimentSelected != null && telescopeSelected != null"
				ng-controller="DatepickerCtrl">
				<h4>3. Choose a date</h4>
				<div style="color: silver">
					<datepicker align="center" class="rowBack" style="color: silver"
						ng-model="dt" min="current" max="'2015-06-22'"
						show-weeks="showWeeks" date-disabled="disabled(date, mode)"></datepicker>
				</div>
			</div>
		</div>
		<div class="container">
			<hr class="divider">
			<div class="animate-show span6"
				ng-show="!loading && dateSelected && available.length == 0">
				<div class="alert">Sorry, there is no timeslot available for
					that day :(</div>
			</div>
			<div class="animate-show span6" ng-show="loading && dateSelected">
				<div class="alert alert-info">Loading...</div>
			</div>
			<div class="animate-show span6" style="text-align: center"
				ng-show="!loading && available.length > 0 && dateSelected">
				<h4 id="timeslotTitle">4. Pick out a timeslot</h4>
				<div id="table" align="center" class="table table-hover"
					style="cursor: pointer; color: #08C;"></div>
				<div id="pagination" class="pagination-centered">
					<ul class="aui-pagination-content">
					</ul>
				</div>
			</div>
			<div class="span5">
				<div class="animate-show" ng-show="slotSelected"
					style="padding-bottom: 3px; text-align: center">
					<h4>5. Confirm it</h4>
					<div class="rowBack" align="center">
						<h5
							style="line-height: 30px; background-color: #f7f7f7; color: #333">Experiment</h5>
						<table style="border: none; width: 80%; text-align: center">
							<tr>
								<td style="width: 50%">Name</td>
								<td><strong>{{experimentSelected}}</strong></td>
							</tr>
							<tr>
								<td style="width: 50%">Telescope</td>
								<td><strong>{{telescopeSelected}}</strong></td>
							</tr>
						</table>
						<h5
							style="line-height: 30px; background-color: #f7f7f7; color: #333">Start</h5>
						<table style="border: none; width: 80%; text-align: center">
							<tr>
								<td style="width: 50%">UT date</td>
								<td><strong>{{slot.begin | UTCDateFilter}}</strong></td>
							</tr>
							<tr>
								<td style="width: 50%">Local time</td>
								<td><strong>{{slot.begin | TimeFilter}}</strong></td>
							</tr>
							<tr>
								<td style="width: 50%">UT time</td>
								<td><strong>{{slot.begin | UTCTimeFilter}}</strong></td>
							</tr>
						</table>
						<h5
							style="line-height: 30px; background-color: #f7f7f7; color: #333">End</h5>
						<table style="border: none; width: 80%; text-align: center">
							<tr>
								<td style="width: 50%">Local date</td>
								<td><strong>{{slot.end | DateFilter}}</strong></td>
							</tr>
							<tr>
								<td style="width: 50%">UT date</td>
								<td><strong>{{slot.end | UTCDateFilter}}</strong></td>
							</tr>
							<tr>
								<td style="width: 50%">Local time</td>
								<td><strong>{{slot.end | TimeFilter}}</strong></td>
							</tr>
							<tr>
								<td style="width: 50%">UT time</td>
								<td><strong>{{slot.end | UTCTimeFilter}}</strong></td>
							</tr>

						</table>
						<!-- <div style="margin-top: 1em;">
							<label class="label"><i class="icon-play"></i><strong>
									Begin </strong></label> {{slot.begin | UTCFullFilter}}
						</div>
						<div style="margin-top: 1em">
							<label class="label"><i class="icon-stop"></i><strong>
									End </strong></label> {{slot.end | UTCFullFilter}}
						</div>-->
						<div ng-show="!reservationDone && !reservationError"
							align="center" style="margin-top: 1em; margin-down: 1em;">
							<button ng-click="reserve()" class="btn btn-info">Request</button>
						</div>
						<div style="margin-top: 30px" class="animate-show"
							ng-show="reservationError">
							<div class="alert">
								<strong>Impossible!</strong> You have reached your maximum
								reservation time.
							</div>
						</div>
						<div style="margin-top: 30px" class="animate-show"
							ng-show="reservationDone">
							<div class="alert">
								<strong>Done!</strong> Your new reservation has been accepted
							</div>
						</div>
						<br>
					</div>
				</div>
			</div>
		</div>
	</div>
</div> 


