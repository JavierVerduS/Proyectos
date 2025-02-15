'use strict';
angular.module('adminApp').factory('adminService', ['$http', function($http) {
    var Action = {};
    var session_id = sessionStorage.getItem('sessionId');
 Action.GetUsers = function() {
        return $http({
            method: 'GET',
            url: 'http://localhost:8080/getUsuarios',
            headers: { 'Authorization': 'Bearer ' + session_id },
            session_id: session_id,
        });
    };
    
    

    Action.GetCategories = function() {
        return $http({
            method: 'GET',
            url: 'http://localhost:8080/getCategorias',
            headers: { 'Authorization': 'Bearer ' + session_id },
             
        });
    };
   
    
    Action.GetVideos = function() {
       
        return $http({
            method: 'GET',
            url: 'http://localhost:8080/getVideos',
            headers: { 'Authorization': 'Bearer ' + session_id },
           
        });
    }
    Action.CreateVideo = function(video) {
        return $http({
            method: 'POST',
            url: 'http://localhost:8080/postVideo',
            headers: { 'Authorization': 'Bearer ' + session_id },
            data: {
                postNameDeVideo: video.name,
                postUrlDeVideo: video.url,
                postNameCategoriaDeVideo: video.category
            }
        });
    }
    Action.DeleteVideo = function(video) {
         
        return $http({
            method: 'DELETE',
            url: 'http://localhost:8080/deleteVideos',
            headers: { 'Authorization': 'Bearer ' + session_id },
            params:{deleteNameVideo: video.title}
             
        });
    } 
    Action.UpdateVideo = function(video) {
        return $http({
            method: 'PATCH',
            url: 'http://localhost:8080/patchVideo',
            headers: { 'Authorization': 'Bearer ' + session_id },
            data: {
                newPatchUrlDeVideo :video.url,
                newPatchNameDeVideo :video.name,
                newPatchCategoriaDeVideo :video.category,
                PatchIdDeVideo : video.id,
  
            }
        });
    }

    Action.CreateCategory = function(category) {
        return $http({
            method: 'POST',
            url: 'http://localhost:8080/postCategorias',
            headers: { 'Authorization': 'Bearer ' + session_id },
            data: {
                nameCategoria: category.name,
            }
        });
    };

    Action.DeleteCategory = function(category) {
         console.log(category.name);
        return $http({
            method: 'DELETE',
            url: 'http://localhost:8080/deleteCategorias',
            headers: { 'Authorization': 'Bearer ' + session_id },
            params:{deleteNameCategoria: category.name}
             
        });
    } 
    Action.UpdateCategory = function(category) {
        return $http({
            method: 'PATCH',
            url: 'http://localhost:8080/patchCategorias',
            headers: { 'Authorization': 'Bearer ' + session_id },
            data: {
                newNameCategoria :category.NewName,
                PatchIdCategoria : category.id,
  
            }
        });
    }
    Action.createUser = function(user) {
        return $http({
            method: 'POST',
            url: 'http://localhost:8080/postUsuario',
            headers: { 'Authorization': 'Bearer ' + session_id },
            data: {
                postNameDeUsuario: user.name,
                postMailDeUsuario: user.mail,
                postPasswdDelUsuario: user.password,
                postRolDeUsuario: user.role
            }
        });
    }
    Action.updateUser = function(user) {
        return $http({
            method: 'PATCH',
            url: 'http://localhost:8080/patchUsuario',
            headers: { 'Authorization': 'Bearer ' + session_id },
            data: {
                newpatchNameDeUsuario :user.newName,
                newpatchMailDeUsuario :user.newMail,
                newpatchPasswdDelUsuario :user.newPassword,
                newpatchROLDelUsuario :user.newRole,
                patchIdUsuario : user.id,
  
            }
        });
    }
    Action.DeleteUser = function(user) {
        return $http({
            method: 'DELETE',
            url: 'http://localhost:8080/deleteUsuarios',
            headers: { 'Authorization': 'Bearer ' + session_id },
            params:{deleteIDUsuario: user.id}
             
        });
    }
    Action.logout = function(sessionId) {
        return $http({
            method: 'Delete',
            url: 'http://localhost:8080/logout',
            headers: { 'Authorization': 'Bearer ' + session_id },
            params:{logoutIDUsuario: sessionId}
        });
    }
    
    return Action;
   
}]);