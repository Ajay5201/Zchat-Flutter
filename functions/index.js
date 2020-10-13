const functions = require('firebase-functions');
const admin=require('firebase-admin');
admin.initializeApp();

  //Create and Deploy Your First Cloud Functions
 //https://firebase.google.com/docs/functions/write-firebase-functions

 //exports.helloWorld = functions.https.onRequest((request, response) => {
   //functions.logger.info("Hello logs!", {structuredData: true});
   //response.send("Hello from Firebase!");


 //};
 //1)
exports.onCreateFollower=functions.firestore
    .document("/followers/{userId}/userfollowers/{followerId}")
    .onCreate(async(snapshot,context)=>
    {
    console.log("follower created",snapshot.id);

    const userId=context.params.userId;
    const followerId=context.params.followerId;

    const followerdPostRef=admin.firestore().collection('posts').doc(userId).collection('userposts');

  const timelinepostRef=admin.firestore().collection('timeline').doc(followerId).collection('timelineposts');

      const querySnapshot= await followerdPostRef.get();

      querySnapshot.forEach(doc=>
      {
      if(doc.exists)
      {
      const postId=doc.id;
      const postData=doc.data();
      timelinepostRef.doc(postId).set(postData);
      }
      })
    });

  //2)
    exports.ondeletefollow=functions.firestore
    .document("/followers/{userId}/userfollowers/{followerId}")
     .onDelete(async(snapshot,context)=>
     {
      console.log("user deleted",snapshot.id);
      const userId=context.params.userId;
          const followerId=context.params.followerId;
const timelinepostRefdel=admin.firestore().collection('timeline').doc(followerId).collection('timelineposts').where("ownerId","==",userId);
const querySnapshot=await timelinepostRefdel.get();

 querySnapshot.forEach(doc=>{
 if(doc.exists)
 {
 doc.ref.delete();
 }
 })
     })


//3)
     exports.onCreatePost=functions.firestore
            .document("/posts/{userId}/userposts/{postId}")
            .onCreate(async (snapshot,context)=>
            {
            const postCreated=snapshot.data();
            const userId=context.params.userId;
            const postId=context.params.postId;

             const userfollowersref=admin.firestore().collection('followers').doc(userId).collection('userfollowers')
             const querySnapshot=await userfollowersref.get();
             querySnapshot.forEach(doc=>{
             const followerId=doc.id;
             admin.firestore().collection('timeline').doc(followerId).collection('timelineposts').doc(postId).set(postCreated);
             })
            })


    //4)
      exports.onUpdatePost=functions.firestore
             .document('/posts/{userId}/userposts/{postId}')
             .onUpdate(async(change,context)=>{
             const postUpdated= change.after.data();
              const userId=context.params.userId;
                         const postId=context.params.postId;
               const userfollowersref=admin.firestore().collection('followers').doc(userId).collection('userfollowers');
                            const querySnapshot=await userfollowersref.get();
                            querySnapshot.forEach(doc=>{
                            const followerId=doc.id;
                            admin.firestore()
                            .collection('timeline')
                            .doc(followerId)
                            .collection('timelineposts')
                            .doc(postId)
                            .get().then(doc=>{
                            if(doc.exists)
                            {
                            doc.ref.update(postUpdated);
                            }
                            });
                            });

             });

       //5)
       exports.onDeletePost=functions.firestore
                    .document("/posts/{userId}/userposts/{postId}")
                    .onDelete(async(snapshot,context)=>{
                    //const postupdated= change.after.data();
                     const userId=context.params.userId;
                                const postId=context.params.postId;
                      const userfollowersref=admin.firestore().collection('followers').doc(userId).collection('userfollowers')
                                   const querySnapshot=await userfollowersref.get();
                                   querySnapshot.forEach(doc=>{
                                   const followerId=doc.id;
                                   admin.firestore().collection('timeline').doc(followerId).collection('timelineposts').doc(postId).get().then(doc=>{
                                   if(doc.exists)
                                   {
                                   doc.ref.delete();
                                   }
                                   });
                                   })

                    })
