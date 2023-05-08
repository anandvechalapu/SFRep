// Apex Class
public with sharing class StudentRecordEditController {

    // Property to hold student records
    public Student__c studentRecord { get; set; }

    // Constructor for the Apex Class
    public StudentRecordEditController() {
        // Initialize student record
        studentRecord = new Student__c();
    }

    // Method to handle updates to Student records
    @AuraEnabled
    public static void updateStudentRecord(Student__c studentRecord) {
        // Validate fields of student record
        List<String> errors = new List<String>();
        if (String.isBlank(studentRecord.Name__c)) errors.add('The student name cannot be blank.');
        if (String.isBlank(studentRecord.Student_ID__c)) errors.add('The student ID cannot be blank.');
        if (String.isBlank(studentRecord.Grade__c)) errors.add('The student grade cannot be blank.');

        // Display validation errors to user
        if (errors.size() > 0) {
            throw new AuraHandledException(String.join(errors, ' '));
        }

        // Update student record
        Database.update(studentRecord);
    }
}

// LWC Component
<template>
    <lightning-record-edit-form object-api-name={studentObjectApiName} record-id={recordId} onsuccess={handleSuccess}>
        <lightning-input-field field-name="Name__c" required>
        </lightning-input-field>
        <lightning-input-field field-name="Student_ID__c" required>
        </lightning-input-field>
        <lightning-input-field field-name="Grade__c" required>
        </lightning-input-field>
        <lightning-button class="slds-m-top_small" variant="brand" type="submit" name="update" label="Update">
        </lightning-button>
    </lightning-record-edit-form>
</template>

import { LightningElement, api, track } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import STUDENT_OBJECT from '@salesforce/schema/Student__c';

export default class StudentRecordEdit extends LightningElement {
    @api recordId;
    @api studentObjectApiName = STUDENT_OBJECT.objectApiName;

    // Handle form submission
    handleSuccess(event) {
        // Prepare the fields to update
        const fields = {
            Id: this.recordId,
            Name__c: event.detail.fields.Name__c.value,
            Student_ID__c: event.detail.fields.Student_ID__c.value,
            Grade__c: event.detail.fields.Grade__c.value
        };

        // Call the Apex controller
        updateStudentRecord({ studentRecord: fields })
            .then(result => {
                // Clear the form
                this.template.querySelector('lightning-record-edit-form').reset();
            })
            .catch(error => {
                // Show an error message
                window.console.log(error);
            });
    }
}