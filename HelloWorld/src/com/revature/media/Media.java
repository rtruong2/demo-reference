package com.revature.media;

import java.io.Serializable;

public abstract class Media implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -986727312276802241L;
	protected String title;
	protected Integer yearPublished;
	protected String genre;
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Integer getYearPublished() {
		return yearPublished;
	}
	public void setYearPublished(int yearPublished) {
		this.yearPublished = yearPublished;
	}
	public String getGenre() {
		return genre;
	}
	public void setGenre(String genre) {
		this.genre = genre;
	}
	@Override
	public String toString() {
		return "Media [title=" + title + ", yearPublished=" + yearPublished + ", genre=" + genre + "]";
	}
	

}
