<%@page import="ticketing.MovieInfoBean"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="mMgr" class="ticketing.TicketingMgr"/>
<%
String movieNm = request.getParameter("movieNm");
String movieIdx = request.getParameter("movieIdx");
String sectionNm = request.getParameter("sectionNm");
String cityIdx = request.getParameter("cityIdx");
String cityNm = request.getParameter("cityNm");
String theaterNm = request.getParameter("theaterNm");
String selectTime = request.getParameter("selectTime");
String tableNm = request.getParameter("tableNm");
String dateIdx = request.getParameter("dateIdx");
String datePage = request.getParameter("datePage");
String printDate = request.getParameter("printDate");
if(!movieIdx.equals("null") && movieIdx.length()>0){
	MovieInfoBean bean = mMgr.getMovieInfo(Integer.parseInt(movieIdx));
	session.setAttribute("movieNm", bean.getMovieNm());
	session.setAttribute("movieDmType", bean.getMovieDmType());
	session.setAttribute("movieAgeLimit", bean.getAgeLimit());
	session.setAttribute("posterPath", bean.getPosterPath());
	session.setAttribute("movieIdx", movieIdx);
}
session.setAttribute("sectionNm", sectionNm);
session.setAttribute("cityIdx", cityIdx);
session.setAttribute("cityNm", cityNm);
session.setAttribute("theaterNm", theaterNm);
session.setAttribute("selectTime", selectTime);
session.setAttribute("tableNm", tableNm);
session.setAttribute("dateIdx", dateIdx);
session.setAttribute("datePage", datePage);
session.setAttribute("printDate", printDate);
if(selectTime!=null&&!selectTime.equals("null")){
	session.setAttribute("changeTime", "Yes");
} else {
	session.setAttribute("changeTime", null);
}
response.sendRedirect("TicketingSection.jsp");
%>