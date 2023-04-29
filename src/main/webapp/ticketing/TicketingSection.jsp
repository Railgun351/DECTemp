<%@page import="java.util.TreeMap"%>
<%@page import="java.util.HashMap"%>
<%@page import="ticketing.ScreeningInfoBean"%>
<%@page import="ticketing.TheaterBean"%>
<%@page import="ticketing.CityBean"%>
<%@page import="ticketing.MovieInfoBean"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="tMgr" class="ticketing.TicketingMgr" />
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
session.setMaxInactiveInterval(30);
String id = (String) session.getAttribute("idKey");
String movieNm = (String) session.getAttribute("movieNm");
String movieIdx = (String) session.getAttribute("movieIdx");
String movieDmType = (String) session.getAttribute("movieDmType");
String movieAgeLimit = (String) session.getAttribute("movieAgeLimit");
String posterPath = (String) session.getAttribute("posterPath");
String sectionNm = (String) session.getAttribute("sectionNm");
String cityIdx = (String) session.getAttribute("cityIdx");
String cityNm = (String) session.getAttribute("cityNm");
cityNm = cityNm!=null&&!cityNm.equals("")?cityNm:"강원";
String theaterNm = (String) session.getAttribute("theaterNm");
String selectTime = (String) session.getAttribute("selectTime");
String tableNm = (String) session.getAttribute("tableNm");
Vector<MovieInfoBean> movieList = tMgr.getMovieList();
Vector<CityBean> cityList = tMgr.getCityList();
Vector<String> theaterList = tMgr.getTheaterNmList(cityNm);
String noImg="https://3.bp.blogspot.com/-WhBe10rJzG4/U4W-hvWvRCI/AAAAAAAABxg/RyWcixpgr3k/s1600/noimg.jpg";
String ageAll="https://i.namu.wiki/i/8smyYc_8tlclJkr6-iED59wAf5cdogXXQj8-vM4zSDOIl0T5WjEywG1QVEsrzCpAhn7AmeDvPXthGSotL4y259tyKZrkfCWsQRzjmtzNcPFdTIWGFv4u3nJsor_gO9MlLTuqhumYrUDbbHReyvp8QA.svg";
String age12="https://i.namu.wiki/i/O2S-WL_0oQ8uxTwTtggflSwP5HtexGmnfodUWs3ww7xHLoXPG_8wirNoHaexMieXGsxdSPqFxrFMdP8PS1L1yKkYpcfSArcY_Wvm1wApxgEVNgIfGtOeWjdBv2eQHCcR4EGL1LnCpIpUwdaieNEy5w.svg";
String age15="https://i.namu.wiki/i/aeORhjozEnc8m-iuqefSMBhghYtXZUXkI88a66N5CcKLNGrzKx9eTNNa7R-vsQjUB9FRpKf3UmVABwcxSPNTKidnMuGPlWktgN-VYqlm6Vt-zHeW0YTxuVRVGwDj1sSqdBOTmi-6XfDIygl7TmatbQ.svg";
String age18="https://i.namu.wiki/i/2e_qQrqlgjMD3gp-Iez13gfUXVRUPM63apODhZlKMI018On-AdQzEoFsNpcb5dTduJZlF8J5HTN58MT39wFpV8ChhhwKanbAeXTCsRNuNWnizNEiswpiAwWwnUkujCKt_k2q-IIJOqADDvZW3GQjhg.svg";
String ageIcon = "";
String ageStr = "";
if(movieAgeLimit!=null){
	if(movieAgeLimit.equals("all")){
		ageIcon = ageAll;
		ageStr = "전체 관람가";
	} else if(movieAgeLimit.equals("12")){
		ageIcon = age12;
		ageStr = "12세 이상 관람가";
	} else if(movieAgeLimit.equals("15")){
		ageIcon = age15;
		ageStr = "15세 이상 관람가";
	} else{
		ageIcon = age18;
		ageStr = "18세 이상 관람가";
	}
}
int datePage = (String)session.getAttribute("datePage")!=null?Integer.parseInt((String)session.getAttribute("datePage")):1;
int dateIdx = (String)session.getAttribute("dateIdx")!=null?Integer.parseInt((String)session.getAttribute("dateIdx")):0;
String printDate = (String)session.getAttribute("printDate");
TreeMap<Integer, Vector<ScreeningInfoBean>> scrnListMap = new TreeMap<Integer, Vector<ScreeningInfoBean>>();
if(movieNm!=null && sectionNm!=null && movieNm.length()>0 && !sectionNm.equals("null")){
	scrnListMap = new TreeMap<Integer, Vector<ScreeningInfoBean>>(tMgr.getScrnList(cityNm, sectionNm, printDate, Integer.parseInt(movieIdx)));
}
%>
<!DOCTYPE unspecified PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<title>예매 페이지</title>
<link href="style.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
<style>
.header {
	background: rgb(51, 51, 51);
	height: 215px;
}

.main {
	background: white;
}

.footer {
	background: darkgray;
	height: 215px;
}

.noneUnderLine {
	text-decoration: none; /* 밑줄 제거 */
	color: inherit; /* 색상 상속 */
}

.tg-0lax {
	align-content: center;
}

#rccl {
	display: flex;
	flex-direction: row;
	justify-content: flex-start; /* 왼쪽 정렬 */
	align-items: center; /* 세로 가운데 정렬 */
}

.items {
	display: inline-table;
	white-space: nowrap;
}
</style>
<link href="css/styles.css" rel="stylesheet" />
<script type="text/javascript">
function SelectCity() {
	var cityIdx = document.getElementById("selectedCity").selectedIndex;
	document.getElementById("cityIdx").value = cityIdx;
	var cityNm = document.getElementById("selectedCity").options[cityIdx].value;
	document.getElementById("cityNm").value = cityNm;
	var cell1 = document.getElementById("sendTheater");
	cell1.value = "null";
	var cell2 = document.getElementById("sendTime");
	cell2.value = "null";
	var table = document.getElementById("sendTable");
	table.value = "null";
	document.ticketingFrm.action = "TicketingProc.jsp";
	document.ticketingFrm.submit();
}
function selectMovie(movieIdx) {
	var cell = document.getElementById("sendMvIdx");
	cell.value = movieIdx;
	var cell1 = document.getElementById("sendTheater");
	cell1.value = "null";
	var cell2 = document.getElementById("sendTime");
	cell2.value = "null";
	var table = document.getElementById("sendTable");
	table.value = "null";
	document.ticketingFrm.action = "TicketingProc.jsp";
	document.ticketingFrm.submit();
}
function selectSection(sectionName) {
	var cell = document.getElementById("sendScNm");
	cell.value = sectionName;
	var cell1 = document.getElementById("sendTheater");
	cell1.value = "null";
	var cell2 = document.getElementById("sendTime");
	cell2.value = "null";
	var table = document.getElementById("sendTable");
	table.value = "null";
	document.ticketingFrm.action = "TicketingProc.jsp";
	document.ticketingFrm.submit();
}
function selectTime(i, j, sTime) {
	var cell1 = document.getElementById("sendTheater");
	cell1.value = (parseInt(i));
	var cell2 = document.getElementById("sendTime");
	cell2.value = sTime;
	var table = document.getElementById("sendTable");
	table.value = i+j+"table";
	document.ticketingFrm.action = "TicketingProc.jsp";
	document.ticketingFrm.submit();
}
function selectDate(dateIdx) {
	var cell = document.getElementById("dateIdx");
	cell.value = dateIdx;
	var today = new Date();
	var targetDay = new Date(today.setDate(today.getDate() + dateIdx));
	document.getElementById("printDate").value = targetDay
			.toLocaleDateString("kr", {
				year : "numeric",
				month : "numeric",
				day : "numeric",
				weekday : "short"
			});
	var cell1 = document.getElementById("sendTheater");
	cell1.value = "null";
	var cell2 = document.getElementById("sendTime");
	cell2.value = "null";
	var table = document.getElementById("sendTable");
	table.value = "null";
	document.ticketingFrm.action = "TicketingProc.jsp";
	document.ticketingFrm.submit();
}
function changeDatePage(datePage) {
	var cell = document.getElementById("datePage");
	cell.value = datePage;
	if(datePage==2){
		selectDate(5);
	} else {
		selectDate(0);
	}
}
</script>
</head>
<body>
	<div class="main">
		<form id="ticketingFrm" name="ticketingFrm" method="post">
			<table class="tg" height="200" width="1500" border="0" align="center"
				style="background: black;">
				<tr>
					<td class="tg-0lax" rowspan="3" width=100><img
						id="printPoster"
						src="<%=posterPath!=null&&!posterPath.equals("")?posterPath:noImg%>"
						width="100%"></td>
					<td id="printMvNm" class="tg-0lax" width=300 height="75"
						style="font-size: 30; padding-left: 10; color: white;"><%=movieNm != null ? movieNm : "영화를 선택해주세요"%></td>
					<td id="printTime" class="tg-0lax" width=300 height="75"
						style="font-size: 30; color: white;">일시: <%=selectTime!=null&&!selectTime.equals("null")?printDate+" "+selectTime:"-"%></td>
					<td class="tg-0lax" rowspan="3" width=150 align="center"><img
						src="https://ifh.cc/g/kgDpPx.png"
						width="150"></td>
				</tr>
				<tr>
					<td id="printMvDT" class="tg-0lax" width=300
						style="padding-left: 10; color: white; font-size: 20;"><%=movieNm!=null ? movieDmType : "영화를 선택해주세요"%></td>
					<td id="printScNm" class="tg-0lax" width=300
						style="color: white; font-size: 20;">극장: <%=sectionNm!=null&&!sectionNm.equals("null") ? sectionNm : "극장을 선택해주세요"%></td>
				</tr>
				<tr>
					<td id="printMvAg" class="tg-0lax" width=300
						style="padding-left: 10; color: white; font-size: 20;"><%=movieNm!=null ? ageStr : "영화를 선택해주세요"%></td>
					<td id="printThNm" class="tg-0lax" width=300
						style="color: white; font-size: 20;">상영관: <%=theaterNm!=null&&!theaterNm.equals("null")?theaterNm+"관":"-"%></td>
				</tr>
			</table>
			<table class="tg2" align="center" border="1" width=1500 height="650"
				style="background: lightyellow;">
				<thead>
					<tr style="background: slategray; color: lavender;">
						<th class="tg-0lax" width=25%>영화</th>
						<th class="tg-0lax" width=15%>극장</th>
						<th class="tg-0lax" width=35%>좌석필터</th>
						<th class="tg-0lax" width=25%>상영일시</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="tg-0lax" height="10%" align="center"><select
							style="width: 30%;">
								<option>예매순</option>
								<option>관객순</option>
								<option>평점순</option>
						</select></td>
						<td class="tg-0lax" height="10%" align="center"><select
							id="selectedCity" style="width: 50%;"
							onchange="javascript:SelectCity()">
								<%
								for (int i = 0; i < cityList.size(); i++) {
								%>
								<option value="<%=cityList.get(i).getAddress()%>"
									<%if(cityIdx!=null&&cityIdx.equals(Integer.toString(i))){%>
									selected <%}%>><%=cityList.get(i).getAddress()%></option>
								<%
								}
								%>
						</select> <input type="hidden" id="cityIdx" name="cityIdx"
							value="<%=cityIdx%>"> <input type="hidden" id="cityNm"
							name="cityNm" value="<%=cityNm%>"></td>
						<td class="tg-0lax" height="10%" align="center"><select
							style="width: 20%;">
								<%
								for (int i = 0; i < 6; i++) {
								%>
								<option value="<%=i + 1%>"><%=i + 1%>관
								</option>
								<%
								}
								%>
						</select></td>
						<td class="tg-0lax" height="10%">
							<table id="DateTable" width="100%">
								<tr>
									<td colspan="7"><div id="DateMonth" align="center">Month</div></td>
								</tr>
								<tr align="center">
									<td><input type="button" <%if(datePage==1){%>
										disabled="disabled" <%}%> onclick="changeDatePage('<%=1%>')"
										value="<"></td>
									<%for(int i=(datePage-1)*5;i<(datePage-1)*5+5;i++){%>
									<td>
										<div>
											<input type="button" id="DateTd<%=i%>" onclick="javascript:selectDate(<%=i%>)"
												style="border: none; width: 40; background: none;<%if(dateIdx==i){%>background: black; color: white;<%}%>">
										</div>
										<div id="WkdTd<%=i%>"></div>
									</td>
									<%}%>
									<td><input type="button" <%if(datePage==2){%>
										disabled="disabled" <%}%> onclick="changeDatePage('<%=2%>')"
										value=">"><input type="hidden" id="dateIdx"
										name="dateIdx" value="<%=dateIdx%>"><input
										type="hidden" id="datePage" name="datePage"
										value="<%=datePage%>"><input type="hidden"
										id="printDate" name="printDate" value="<%=printDate%>"></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="tg-0lax" rowspan="5">
							<div style="height: 100%; width: 100%; overflow: auto;">
								<%
									for (int i = 0; i < movieList.size(); i++) { String icon="";
									String age=movieList.get(i).getAgeLimit();
									if(age.equals("all")){icon=ageAll;}
									else if(age.equals("12")) {icon=age12;}
									else if(age.equals("15")) {icon=age15;}
									else {icon=age18;}
									%>
								<table width=100%>
									<tr>
										<td class="rccl"
											<%if(movieList.get(i).getMovieNm().equals(movieNm)){%>
											style="background: lightgray;" <%}%>><a
											href="javascript:selectMovie('<%=movieList.get(i).getIdx()%>')"
											class="noneUnderLine"> <img width="22" src="<%=icon%>">
												<%=movieList.get(i).getMovieNm()%>
										</a></td>
									</tr>
								</table>
								<p></p>
								<%
									}
									%>
								<input type="hidden" id="sendMvIdx" name="movieIdx"
									value="<%=movieIdx%>">
							</div>
						</td>
						<td class="tg-0lax" rowspan="5">
							<div style="height: 100%; width: 100%; overflow: auto;">
								<table id="regionTable" width=100%>
									<%
									for (int i = 0; i < theaterList.size(); i++) {
									%>
									<tr>
										<td <%if(theaterList.get(i).equals(sectionNm)){%>
											style="background: lightgray;" <%}%>><a
											href="javascript:selectSection('<%=theaterList.get(i)%>')"
											class="noneUnderLine"><%=theaterList.get(i)%></a></td>
									</tr>
									<%
									}
									%>
								</table>
								<input type="hidden" id="sendScNm" name="sectionNm"
									value="<%=sectionNm%>">
							</div>
						</td>
						<td class="tg-0lax" rowspan="2" height="95"
							style="background: white;">좌석필터배치도</td>
						<td id="minimovieNm" class="rccl" height="10%" align="center">
							<%if(movieNm!=null){%> <img id="testId" name="TestName" width=22
							src="<%=ageIcon%>"> <%}%> <%=movieNm != null ? movieNm : "영화를 선택해주세요"%></td>
					</tr>
					<tr>
						<td class="tg-0lax" rowspan="4">
							<div style="height: 100%; width: 100%; overflow: auto;">
								<%
								if(scrnListMap.size()>0){
								for (int i : scrnListMap.keySet() ) {
									Vector<ScreeningInfoBean> vlist = scrnListMap.get(i);
								%>
								<p style="font-size: 22px">
									2D |
									<%=i%>관
								</p>
								<%
								for (int j = 0; j < vlist.size(); j++) {
									ScreeningInfoBean bean = vlist.get(j);
									String splitSpace[] = bean.getScreenTime().split(" ");
									String splitColon[] = splitSpace[1].split(":");
									String timeText = splitColon[0]+":"+splitColon[1];
								%>
								<table class="items" border="1" width="70"
									onclick="selectTime('<%=i%>','<%=j%>','<%=timeText%>')">
									<tr>
										<td align="center"
											style="background: <%if((""+i+j+"table").equals(tableNm)){%>lightgray<%}else{%>white<%}%>;">
											<div style="font-size: 10px;"><%=i%>관
											</div>
											<div id="<%=j%>" style="font: bold; font-size: 20px"><%=timeText%></div>
											<div style="font-size: 12px"><%=bean.getReservedSeat()%>/<%=bean.getTotalSeat()%></div>
										</td>
									</tr>
								</table>
								<%
										}
								%>
								<hr>
								<%
									}
								} else {
								%>
								<table height="100%" align="center">
									<tr>
										<td>
											<div align="center" style="vertical-align: middle;">
												<i class="bi bi-film" style="font-size: 30;"></i>
												<br>조회 가능한 상영시간이 없습니다.<br>조건을 변경해주세요.
											</div>
										</td>
									</tr>
									<tr height="50%">
										<td></td>
									</tr>
								</table>
								<%}%>
								<input type="hidden" id="sendTheater" name="theaterNm"
									value="<%=theaterNm%>"> <input type="hidden"
									id="sendTime" name="selectTime" value="<%=selectTime%>">
								<input type="hidden" id="sendTable" name="tableNm"
									value="<%=tableNm%>">
							</div>
						</td>
					</tr>
					<tr style="background: slategray; color: lavender;">
						<td class="tg-0lax" height="5%" align="center">좌석현황</td>
					</tr>
					<tr>
						<td class="tg-0lax" rowspan="2" height="100%">
							<iframe id="seatIframe" width="100%" height="100%" src="/DEC/ticketing/TicketingSeat.jsp"></iframe>
						</td>
					</tr>
					<tr>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<script>
	for(var i=<%=(datePage-1)*5%>;i<<%=(datePage-1)*5+5%>; i++) {
			var now = new Date();
			var targetDay = new Date(now.setDate(now.getDate() + i));
			var day = targetDay.toLocaleDateString("en-us", {
				day : "numeric"
			});
			var weekday = targetDay.toLocaleDateString("kr", {
				weekday : "short"
			});
			document.getElementById("DateTd" + i).value = day;
			document.getElementById("WkdTd" + i).innerHTML = weekday;
			if (weekday == "토") {
				document.getElementById("WkdTd" + i).style.color = "blue";
				if(i!=<%=dateIdx%>){
					document.getElementById("DateTd" + i).style.color = "blue";
				}
			} else if (weekday == "일") {
				document.getElementById("WkdTd" + i).style.color = "red";
				if(i!=<%=dateIdx%>){
					document.getElementById("DateTd" + i).style.color = "red";
				}
			}
		}
		var now = new Date();
		var targetDay = new Date(now.setDate(now.getDate() + <%=dateIdx%>));
		document.getElementById("DateMonth").innerHTML = targetDay
				.toLocaleDateString("kr", {
					month : "numeric"
				});
		if("<%=printDate%>" == "null") {
			selectDate(0);
		}
	</script>
</body>