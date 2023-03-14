class student_needs {
   String item, description, volunteer_id, quantity_required, batch, batchClass,status="pending approval";

  //['slot_id','pathshaala','batch','day','description','time_start','time_end', 'remarks']
  student_needs.fromJson(Map json)
      : item = json["item"].toString(),
        description = json["description"] ?? json["description"].toString(),
        volunteer_id = json["volunteer_id"].toString(),
        quantity_required = json["quantity_required"],
        batch = (json['batch'] ?? "").toString(),
        batchClass = (json['batch_remarks'] ?? "").toString();
}

// class student_needs_admin{
//   String item, description, volunteer_id, quantity_required, batch, batchClass,status;
//
//   //['slot_id','pathshaala','batch','day','description','time_start','time_end', 'remarks']
//   student_needs_admin.fromJson(Map json)
//       : item = json["item"].toString(),
//         description = json["description"] ?? json["description"].toString(),
//         volunteer_id = json["volunteer_id"].toString(),
//         quantity_required = json["quantity_required"],
//         batch = (json['batch'] ?? "").toString(),
//         batchClass = (json['batch_remarks'] ?? "").toString(),
//         status= (json['status'] ?? "").toString();
//
// }