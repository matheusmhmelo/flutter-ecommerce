import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp(functions.config().firebase);

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onCall((data, context) => {
  return {
    data: "Hello from Cloud Functions"
  }
});

export const getUserData = functions.https.onCall( async (data, context) => {
  if(!context.auth){
    return {
      "data": "Nenhum usuário logado"
    };
  }

  const snapshot = await admin.firestore().collection("users").doc(context.auth.uid).get();
  return {
    "data": snapshot.data()
  };

});

export const addMessage = functions.https.onCall(async (data, context) => {
  const snapshot = await admin.firestore().collection("messages").add(data);

  return {
    "success": snapshot.id
  }
});

export const onNewOrder = functions.firestore.document("/orders/{orderId}").onCreate((snapshot, context) => {
  const orderId = context.params.orderId;
  console.log(orderId);
})