package ticketing;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Vector;
import dbcon.DBConnectionMgr;

public class TicketingMgr {

	private DBConnectionMgr pool;

	public TicketingMgr() {
		pool = DBConnectionMgr.getInstance();
	}

	public Vector<MovieInfoBean> getMovieList() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<MovieInfoBean> vlist = new Vector<>();
		try {
			con = pool.getConnection();
			sql = "select * from movieinfo";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				MovieInfoBean bean = new MovieInfoBean(rs.getInt("idx"), rs.getString("name"), "2D",
						rs.getString("agelimit"), rs.getString("photo"), rs.getString("director"),
						rs.getString("actor"), rs.getString("genre"), rs.getString("intro"), rs.getString("opendt"),
						rs.getString("enddt"), rs.getString("runtime"), rs.getString("trailer"));
				vlist.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}

	public MovieInfoBean getMovieInfo(int idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		MovieInfoBean bean = new MovieInfoBean();
		try {
			con = pool.getConnection();
			sql = "select * from movieinfo where idx = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, idx);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				bean.setIdx(idx);
				bean.setMovieNm(rs.getString("name"));
				bean.setAgeLimit(rs.getString("agelimit"));
				bean.setPosterPath(rs.getString("photo"));
				bean.setMovieDmType("2D");
				bean.setDirector(rs.getString("director"));
				bean.setActor(rs.getString("actor"));
				bean.setGenre(rs.getString("genre"));
				bean.setIntro(rs.getString("intro"));
				bean.setOpenDt(rs.getString("opendt"));
				bean.setEndDt(rs.getString("enddt"));
				bean.setRuntime(rs.getString("runtime"));
				bean.setTrailerPath(rs.getString("trailer"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}

	public Vector<CityBean> getCityList() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<CityBean> vlist = new Vector<>();
		try {
			con = pool.getConnection();
			sql = "select * from city";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				CityBean bean = new CityBean(rs.getString("address"), rs.getInt("num"));
				vlist.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}

	public Vector<TheaterBean> getTheaterList() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<TheaterBean> vlist = new Vector<>();
		try {
			con = pool.getConnection();
			sql = "select * from theater";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				TheaterBean bean = new TheaterBean(rs.getString("theaterName"), rs.getInt("seat"), rs.getInt("theaterNum"),
						rs.getString("city_address"));
				vlist.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}

	public Vector<String> getTheaterNmList(String city) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<String> vlist = new Vector<>();
		try {
			con = pool.getConnection();
			sql = "select DISTINCT theaterName from theater where city_address = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, city);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				vlist.add(rs.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}

	public HashMap<Integer, Vector<ScreeningInfoBean>> getScrnList(String city, String section, String date,
			int movieIdx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		HashMap<Integer, Vector<ScreeningInfoBean>> scrnListMap = new HashMap<Integer, Vector<ScreeningInfoBean>>();
		String temp[] = date.split("[.]");
		try {
			con = pool.getConnection();
			sql = "SELECT s.movieIdx, s.city_address, s.sectionName, s.theaterNum, s.screenTime, s.reservedSeats, t.seat\r\n"
					+ "FROM screeninginfo s, theater t\r\n"
					+ "WHERE s.city_address=t.city_address AND s.sectionName=t.theaterName AND s.theaterNum=t.theaterNum"
					+ " AND s.city_address=? AND s.sectionName=? AND s.screenTime between ? and ? AND s.movieIdx=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, city);
			pstmt.setString(2, section);
			pstmt.setString(3, temp[0].trim() + "-" + temp[1].trim() + "-" + temp[2].trim() + " 00:00:00");
			pstmt.setString(4, temp[0].trim() + "-" + temp[1].trim() + "-" + temp[2].trim() + " 23:59:59");
			pstmt.setInt(5, movieIdx);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				String[] reservedSeat = rs.getString("reservedSeats").split("/");
				Vector<String> vRS = new Vector<String>(Arrays.asList(reservedSeat));
				ScreeningInfoBean bean = new ScreeningInfoBean(rs.getInt("movieIdx"), city, section,
						rs.getInt("theaterNum"), rs.getString("screenTime"), rs.getInt("seat"),
						reservedSeat.length, vRS);
				if (scrnListMap.get(bean.getTheaterNum()) != null) {
					scrnListMap.get(bean.getTheaterNum()).add(bean);
				} else {
					Vector<ScreeningInfoBean> vlist = new Vector<>();
					vlist.add(bean);
					scrnListMap.put(bean.getTheaterNum(), vlist);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return scrnListMap;
	}
	
	public Vector<SeatBean> getSeatInfo(int movieIdx, String city, String section, int theaterNum, String date, String time) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<SeatBean> vlist = new Vector<>();
		String temp[] = date.split("[.]");
		String screenTime = temp[0].trim() + "-" + temp[1].trim() + "-" + temp[2].trim() + " " + time;
		String seatPosition[][] = new String[26][15];
		for (int i = 0; i < seatPosition.length; i++) {
			for (int j = 0; j < seatPosition[i].length; j++) {
				seatPosition[i][j] = new String();
				if(j<9) {
					seatPosition[i][j] = "" + (char) (i + 65) + "0" + (j+1);
				} else {
					seatPosition[i][j] = "" + (char) (i + 65) + (j+1);
				}
			}
		}
		try {
			con = pool.getConnection();
			sql = "SELECT s.reservedSeats, t.seat\r\n"
					+ "FROM screeninginfo s, theater t\r\n"
					+ "WHERE s.city_address=t.city_address AND s.sectionName=t.theaterName AND s.theaterNum=t.theaterNum AND "
					+ "s.movieIdx = ? and s.city_address = ? and s.sectionName = ? and s.theaterNum = ? and s.screenTime = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, movieIdx);
			pstmt.setString(2, city);
			pstmt.setString(3, section);
			pstmt.setInt(4, theaterNum);
			pstmt.setString(5, screenTime);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				String[] rsvS = rs.getString(1).split("/");
				Vector<String> rsvSv = new Vector<>(Arrays.asList(rsvS));
				for (int i = 0; i < rs.getInt(2); i++) {
					if (rsvSv.size()>0) {
						for(int j=0;j<rsvSv.size();j++) {
							if (rsvSv.get(j).equals(seatPosition[(int) (i / 15.0)][i % 15])) {
								rsvSv.remove(j);
								SeatBean bean = new SeatBean(seatPosition[(int) (i / 15.0)][i % 15], 2);
								vlist.add(bean);
								break;
							}
							if (j == rsvSv.size()-1) {
								SeatBean bean = new SeatBean(seatPosition[(int) (i / 15.0)][i % 15], 0);
								vlist.add(bean);
							}
						}
					} else {
						SeatBean bean = new SeatBean(seatPosition[(int) (i / 15.0)][i % 15], 0);
						vlist.add(bean);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}

	public int deletePastTime() {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		int updateRows = 0;
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			con = pool.getConnection();
			sql = "delete from screeninginfo where screenTime < ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, transFormat.format(new Date()));
			updateRows = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return updateRows;
	}
}
