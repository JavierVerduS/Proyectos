package v0;

import java.io.File;
import java.io.Serializable;
import java.nio.file.Path;

public class FileInfo	implements Serializable {
	  private static final long serialVersionUID = 1L;
	protected String name;
	protected long tamanoNumerodeBytes;
	protected File UPCTSHIT;
	FileInfo( File UPCTSHIT){
		this.UPCTSHIT=UPCTSHIT;
		this.name=UPCTSHIT.getName();
		this.tamanoNumerodeBytes=UPCTSHIT.length();
				 //clase path crear directamente
	}

	public String getName() {
		return name;
	}
	public File getFile() {
		
		return UPCTSHIT;
		
	}

	public void setName(String name) {
		this.name = name;
	}

	public long getTamañoNumerodeBytes() {
		 
		return tamanoNumerodeBytes;
	}

	public void setTamañoNumerodeBytes(long tamañoNumerodeBytes) {
		this.tamanoNumerodeBytes = tamañoNumerodeBytes;
	}
	 
	
}
