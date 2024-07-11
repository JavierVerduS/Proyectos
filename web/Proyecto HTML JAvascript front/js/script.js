const form = document.querySelector('form');

form.addEventListener('submit', (event) => {
  // Prevenir el comportamiento por defecto del formulario
  event.preventDefault();

  // Obtener los valores de los campos de usuario y contraseña
  const username = event.target.querySelector('#floatingInput').value;
  const password = event.target.querySelector('#floatingPassword').value;
   
 // Validar los valores de los campos
 if (!username || !password) {
    alert('Debes completar todos los campos');
    return;
  }

  const myHeaders = new Headers();
  myHeaders.append("Content-Type", "application/json");

  const raw = JSON.stringify({
    "correo": username,
    "password": password
  });
 
  const requestOptions = {
    method: "POST",
    headers: myHeaders,
    body: raw,
    redirect: "follow"
  };

  fetch("https://labingsoft.onrender.com/api/auth/login", requestOptions)
    .then((response) => response.json())
    .then((data) => { // Aquí se utiliza directamente el objeto 'data'
      console.log(data);
      if(data.usuario.rol==="ADMIN_ROLE"){
        localStorage.setItem("Admin", "true");
        localStorage.setItem("Token", data.token);
        window.location.href = 'AdminPanel.html';
      }else{
      localStorage.setItem("Token", data.token);
      window.location.href = 'home.html';
    }
    })
    
    .catch((error) => console.error(error));
});
