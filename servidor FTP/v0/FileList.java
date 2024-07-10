package v0;

import java.io.Serializable;
import java.util.ArrayList;

public class FileList implements Serializable {
	 private static final long serialVersionUID = 1L;
	ArrayList<FileInfo> archivos;
	ArrayList<FileInfo> directorios;
	//PREGUNTAR PROFESOR QUE TIENE ESTO QUE VER CON QUE EL METODO
	//imprimeMiLista NO DE VALORES DUPLICADOS
	/* ArrayList<FileInfo> archivos;
    ArrayList<FileInfo> directorios;
     FileList(ArrayList<FileInfo> archivos,ArrayList<FileInfo> directorios){
        this.archivos=archivos;
        this.directorios=directorios;
     }*/
	 FileList(ArrayList<FileInfo> archivos, ArrayList<FileInfo> directorios) {
	        this.archivos = (archivos != null) ? new ArrayList<>(archivos) : new ArrayList<>();
	        this.directorios = (directorios != null) ? new ArrayList<>(directorios) : new ArrayList<>();
	    } 

	public ArrayList<FileInfo> getArchivos() {
		return archivos;
	}
	public void setArchivos(ArrayList<FileInfo> archivos) {
		this.archivos = archivos;
	}
	public void AddArchivos( FileInfo archivos) {
		 this.archivos.add(archivos);
	}
	public void AddDirectorio( FileInfo directorio) {
		 this.directorios.add(directorio);
	}
	public ArrayList<FileInfo> getDirectorios() {
		return directorios;
	}
	public void setDirectorios(ArrayList<FileInfo> directorios) {
		this.directorios = directorios;
	}
}
