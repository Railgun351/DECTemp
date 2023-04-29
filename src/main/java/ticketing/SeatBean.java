package ticketing;

public class SeatBean {
	private String seatPosition;
	private int status;
	
	public SeatBean() {
		
	}
	
	public SeatBean(String seatPosition, int status) {
		super();
		this.seatPosition = seatPosition;
		this.status = status;
	}
	public String getSeatPosition() {
		return seatPosition;
	}
	public void setSeatPosition(String seatPosition) {
		this.seatPosition = seatPosition;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	
}
