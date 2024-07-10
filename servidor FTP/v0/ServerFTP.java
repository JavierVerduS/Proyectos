package v0;

import java.util.*;
import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.io.*;

public class ServerFTP extends UnicastRemoteObject implements FTPInterfaz {
	private static final long serialVersionUID = 1L;

	private FileChannel fc;
	private ByteBuffer bloque;

	protected ServerFTP() throws RemoteException {
		super();

	}

	String RutaDestino = "E:TelematicaLocal\\SDjava\\pruebasServer";

	@Override
	public FileList listFiles(String ruta) throws RemoteException {

		File miFileList = new File(ruta);
		File[] files = miFileList.listFiles();

		FileList miVerdaderoFileList = new FileList(null, null);

		for (File f : files) {
			FileInfo pepe = new FileInfo(f);

			if (f.isFile()) {
				pepe.setName(f.getName());

				pepe.setTamañoNumerodeBytes(f.length());

				miVerdaderoFileList.AddArchivos(pepe);
			} else if (!f.isFile()) {

				pepe.setName(f.getName());

				pepe.setTamañoNumerodeBytes(f.length());

				miVerdaderoFileList.AddDirectorio(pepe);
			}

		}
		return miVerdaderoFileList;
	}

	public String ImprimemeMiLista(FileList JuanAlberto) {
		ArrayList<FileInfo> Archivos = JuanAlberto.getArchivos();
		ArrayList<FileInfo> Directorios = JuanAlberto.getDirectorios();
		int i = 0;
		StringBuilder global = new StringBuilder("la lista es \n");

		for (FileInfo f : Archivos) {
			i++;
			global.append("el archivo ").append(i).append(" es:").append(f.getName()).append(" y pesa:")
					.append(f.getTamañoNumerodeBytes()).append("\n");

		}
		i = 0;
		for (FileInfo f : Directorios) {
			i++;
			global.append("el directorio ").append(i).append(" es:").append(f.getName()).append("\n");

		}
		return global.toString();
	}

	@Override
	public void CreateFolder(String ruta, String name, String si) throws RemoteException {
		String RutaDEfinitiva = ruta.concat("/" + name);
		File folder = new File(RutaDEfinitiva);

		if (si.equals("si")) {
			File fichero = new File(RutaDEfinitiva);
			try {
				fichero.createNewFile();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {

			if (!folder.exists()) {
				if (folder.mkdirs()) {
					System.out.println("Folder created successfully");
				} else {
					System.out.println("Failed to create folder");
				}
			} else {
				System.out.println("Folder already exists");
			}
		}
	}

	@Override
	public void DeleteFolder(String ruta, String name) throws RemoteException {
		String RutaDEfinitiva = ruta.concat("/" + name);
		File folder = new File(RutaDEfinitiva);

		if (folder.exists()) {
			if (folder.delete()) {
				System.out.println("Folder deleted successfully");
			} else {
				System.out.println("Failed to delete folder");
			}
		} else {
			System.out.println("Folder does not exist");
		}
	}

	public byte[] downloadFile(String nomreArchivo, FileList lista, long offset, int resto) throws RemoteException {
		try {
			ArrayList<FileInfo> ArchivosServer = lista.getArchivos();
			byte[] buffer = new byte[1024 * 8]; // buffer 1Mb
			File ArchivoQueQUieroDescargar = null;

			for (FileInfo f : ArchivosServer) {
				if (f.getName().equals(nomreArchivo)) {
					ArchivoQueQUieroDescargar = f.getFile();

				}
			}

			// RandomAccessFile fr = new RandomAccessFile(ArchivoQueQUieroDescargar, "r");

			/*
			 * Lee desde el offset hasta el resto y lo almacena en el buffer fr.read(buffer,
			 * offset, resto);
			 * 
			 * fr.close(); return buffer;
			 * 
			 * 
			 */
			try (RandomAccessFile fr = new RandomAccessFile(ArchivoQueQUieroDescargar, "r")) {
				// Set the file pointer to the correct offset
				fr.seek(offset);
				// Read data into the buffer
				fr.read(buffer, 0, resto);
			}

			return buffer;

		} catch (IOException e) {
			e.printStackTrace();
			throw new RemoteException("Error downloading file: " + e.getMessage());
		}
	}
	/*
	 * public byte[] downloadFile(String Archivo, FileList lista, String
	 * destinationPath,int offset,int resto) throws RemoteException { try {
	 * ArrayList<FileInfo> ArchivosServer = lista.getArchivos();
	 * 
	 * for (FileInfo f : ArchivosServer) { if (f.getName().equals(Archivo)) { File
	 * ArchivoQueQuieroDescargar = f.getFile();
	 * 
	 * try (RandomAccessFile fr = new RandomAccessFile(ArchivoQueQuieroDescargar,
	 * "r")) { byte[] buffer = new byte[1024 * 8]; // 8KB buffer
	 * 
	 * 
	 * 
	 * ByteArrayOutputStream baos = new ByteArrayOutputStream();
	 * 
	 * 
	 * baos.write(buffer, offset, resto);
	 * 
	 * return baos.toByteArray(); }
	 * 
	 * 
	 * 
	 * } }
	 * 
	 * 
	 * System.out.println("File not found in the server: " + Archivo); } catch
	 * (IOException e) { e.printStackTrace();
	 * System.err.println("Error downloading file: " + e.getMessage()); } return
	 * null; }
	 * 
	 */

	@Override
	public void SubirArchivo(String ArchivoSubirPC, FileList listarutaPC) throws RemoteException {
//esta lista es una ruta local del pc para buscar archivo en su PC
		ArrayList<FileInfo> ArchivosPC = listarutaPC.getArchivos();
		byte[] buffer = new byte[1024 * 8]; // buffer 1Mb
		long offset = 0;
		int Resto = 0;
		int cont = 0;
		long numPaquetes = 0;
		for (FileInfo f : ArchivosPC) {

			if (f.getName().equals(ArchivoSubirPC)) {
				System.out.println("el nombre " + f.getName() + "con ruta " + ArchivoSubirPC);
				File ArchivoQueQUieroDescargar = f.getFile();
				System.out.println(ArchivoQueQUieroDescargar.getName());
				long TamanoArchivoQueQuieroDescargar = ArchivoQueQUieroDescargar.length();

				numPaquetes = (long) Math.floor(TamanoArchivoQueQuieroDescargar / buffer.length) + 1;
				String RutaDefinitiva = RutaDestino.concat("\\" + ArchivoSubirPC);
				Resto = (int) (TamanoArchivoQueQuieroDescargar % buffer.length);

				try (FileOutputStream ArchivoNuevo = new FileOutputStream(RutaDefinitiva);) {

					while (numPaquetes >= 1) {
						ArchivoNuevo.write(downloadFile(ArchivoSubirPC, listarutaPC, offset, 1024 * 8));

						offset += 1024 * 8;

						cont++;
						numPaquetes--;
						System.out.println(
								" este es el paquete que ha llegado con  numero " + cont + " y el total de paquetes es"
										+ numPaquetes + " y el ultimo pesa " + Resto + " y el ofset es :" + offset);

					}
					ArchivoNuevo.write(downloadFile(ArchivoSubirPC, listarutaPC, offset, Resto));

				} catch (IOException e) {
					e.printStackTrace();
				}

				System.out.println("File downloaded successfully.");
			}

		}

	}

}

/*
 * public static void readFilesInDirectory(String directoryPath) { File
 * directory = new File(directoryPath); File[] files = directory.listFiles();
 * 
 * if (files != null) { for (File file : files) { if (file.isFile()) {
 * System.out.println("File: " + file.getName()); } } } }
 */