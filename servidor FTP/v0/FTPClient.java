package v0;

import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.channels.FileChannel;
import java.util.Scanner;

public class FTPClient {

	public static void main(String[] args) throws RemoteException, MalformedURLException, NotBoundException {
		// cast se hace siempre a la interfaz
		FTPInterfaz t = (FTPInterfaz) Naming.lookup("rmi://localhost:5670/FTPInterfaz"); // el objeto interfaz aqui pide
		long Longitud = 0;
		int buffer = 1024 * 8;
		int cont = 0;
		long numPaquetes = 0;
		int Resto = 0;
		File ArchivoQueQUierollenar = null;
		long offset = 0;
		String Archivo; // que lo emta por teclado
						// a el registro donde esten
						// implementadas las
		// Suponemos que esta es la ruta del servidor Tendras que modificarlo

		FileList miListaServer = t.listFiles("E:\\TelematicaLocal\\SDjava\\pruebasServer");
		FileList miListaPC = t.listFiles("E:\\TelematicaLocal\\SDjava\\pruebasCliente");

		ArrayList<FileInfo> ArchivosServer = miListaServer.getArchivos();
		ArrayList<FileInfo> ArchivosPC = miListaPC.getArchivos();

		// t.CreateFolder("E:\\SDjava\\pruebas", "JAMON");

		// t.DeleteFolder("E:\\SDjava\\pruebas", "JAMON");

		System.out.println("Bienvenido Al FTP de Javier Verdú y Angel Madrid");
		opciones: do {

			System.out.println("Introduce (1) para ver archivos Disponibles en el Servidor " + "\n"
					+ "Intruduce (2) para Introducir tu ruta y ver tus archivos " + "\n"
					+ "Introduce (3) para descargar archivos del servidor " + "\n"
					+ "Introduce(4) para subir un archivo al servidor  \n" + 
					"Introduce (5) para borrar carpetas o archivos en Servidor o pc "
					+ "\n" + "Introduce (6) para crear carpetas En el servidor o pc  " + "\n");

			Scanner scanner = new Scanner(System.in);
			int Opcion = scanner.nextInt();
			switch (Opcion) {
			case 1:
				System.out.println("funciona?");
				String juan = t.ImprimemeMiLista(miListaServer);
				System.out.println(juan);
				System.out.println("pulsa c para volver");
				String continuar = scanner.next();
				if (continuar.equals("c")) {
					continue opciones;
				}
			case 2:
				System.out.println("introduce una ruta");
				String ruta = scanner.next();
				String Mio = t.ImprimemeMiLista((t.listFiles(ruta)));
				System.out.println(Mio);

				System.out.println("pulsa c para volver");
				String continuar2 = scanner.next();
				if (continuar2.equals("c")) {
					continue opciones;
				}
			case 3:
				System.out.println(" 1 Introduce el archivo que quieres descargar \n");
				String ArchivoDescarga = scanner.next();
				System.out.println("2 Introduce la ruta en la que lo quieres descargar \n");
				String DescargaRuta = scanner.next();
				for (FileInfo f : ArchivosServer) {
					if (f.getName().equals(ArchivoDescarga)) {

						Longitud = f.getTamañoNumerodeBytes();
						System.out.println(Longitud);
						numPaquetes = (long) Math.floor(Longitud / buffer) + 1;
						System.out.println("los numeros de paquetes necasarios son:  " + numPaquetes);
						Resto = (int) (Longitud % buffer);

					}
				}

				try (FileOutputStream fos = new FileOutputStream(DescargaRuta.concat("\\").concat(ArchivoDescarga))) {

					while (numPaquetes >= 1) {

						fos.write(t.downloadFile(ArchivoDescarga, miListaServer, offset, 1024 * 8));

						offset += buffer;
						Longitud -= buffer;
						System.out.println(
								" este es el paquete que ha llegado con  numero " + cont + " y el total de paquetes es"
										+ numPaquetes + " y el ultimo pesa " + Resto + " y el ofset es :" + offset);
						cont++;
						numPaquetes--;
					}
					fos.write(t.downloadFile("Juan.mp4", miListaServer, offset, Resto));

				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				System.out.println("pulsa c para volver");
				String continuar3 = scanner.next();
				if (continuar3.equals("c")) {
					continue opciones;
				}
			case 4:
				System.out
						.print(" 1 introduce que archivo quieres subir al servidor con nombre completo y extension \n");
				String ArchivoSubida = scanner.next();

				t.SubirArchivo(ArchivoSubida, miListaPC);
				System.out.println("Dowloand Succesfully \n");
				System.out.println("pulsa c para volver");
				String continuar4 = scanner.next();
				if (continuar4.equals("c")) {
					continue opciones;
				}

			case 5:
				System.out.print(" introduce la ruta donde  quieres borrar Cosas en el servidor o pc  \n");
				String Ruta = scanner.next();

				System.out.print(" Quieres borrar un archivo? introduce si ");
				String si = scanner.next();
				if (si.equals("si")) {
					System.out.print("introduce el archivo  que quieres borrar en el servidor o pc");
					String ArchivoBorrar = scanner.next();
					t.DeleteFolder(Ruta, ArchivoBorrar);
				} else {
					System.out.print("introduce la carpeta  que quieres borrar en el servidor o pc");
					String CarpetaBorrar = scanner.next();
					t.DeleteFolder(Ruta, CarpetaBorrar);
				}
				System.out.println("pulsa c para volver");
				String continuar5 = scanner.next();
				if (continuar5.equals("c")) {
					continue opciones;
				}
			case 6:
				System.out.print(" introduce la ruta donde  quieres crear en el servidor o pc  \n");
				String Ruta2 = scanner.next();

				System.out.print(" Quieres crear un archivo? introduce si, introduce NO para crear una carpeta ");
				String si2 = scanner.next();
				if (si2.equals("si")) {
					System.out.print(
							"introduce el archivo  que quieres crar en el servidor o pc con nombre y extension completa");
					String ArchivoCrear = scanner.next();
					t.CreateFolder(Ruta2, ArchivoCrear, si2);
				} else {
					System.out.print("introduce la carpeta  que quieres crear en el servidor o pc");
					String CarpetaCrear = scanner.next();
					t.CreateFolder(Ruta2, CarpetaCrear, "que no");
				}
				System.out.println("pulsa c para volver");
				String continuar6 = scanner.next();
				if (continuar6.equals("c")) {
					continue opciones;
				}

			}
		} while (true);
	}

}
