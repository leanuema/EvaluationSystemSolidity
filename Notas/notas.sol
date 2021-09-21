// SPDX-License_Identifier: MIT
pragma solidity >=0.5.4 <0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------
//  ALUMNO  /   ID  /   NOTA
// -----------------------------
//  Marcos  /   77755N  /   5
//  Joan    /   12345X  /   9
//  Maria   /   02468T  /   2
//  Marta   /   13579U  /   3
//  Alba    /   98765Z  /   5

contract Notes {

    //  Teacher address
    address public teacher;

    //Constructor
    constructor() public {
        teacher = msg.sender;
    }

    //Mapping para relacionar el hash(bytes32) del alumno con su nota de examen
    mapping(bytes32 => uint) notesMapping;

    // lista de alumnos de revision de examen
    string[] reviewList;

    //Events
    event evaluated_student(bytes32, uint);
    event revision_event(string);

    //  control de funciones ejecutables
    modifier teacherOnly(address teacher_address) {
        //  validar que la direccion por parametro sea la del owner del contracto
        require(teacher_address == msg.sender, "Error, permission denied");
        _;
    }

    //  evaluating students function
    function evaluate(string memory studentId, uint note) public teacherOnly(msg.sender) {
        //  identification student hash
        bytes32 studentIdHash = keccak256(abi.encodePacked(studentId));
        //  relation between identification student hash and his note
        notesMapping[studentIdHash] = note;
        //  emision del evento
        emit evaluated_student(studentIdHash, note);
    }

    function view_notes(string memory studentId) public view returns (uint) {
        bytes32 studentIdHash = keccak256(abi.encodePacked(studentId));
        return notesMapping[studentIdHash];
    }

    //  funcion para pedir una revision
    function exam_review(string memory studentId) public {
        //  almacenamiento de la identidad del alumno
        reviewList.push(studentId);
        emit revision_event(studentId);
    }

    //  funcion para ver los alumnos que solicitaron revision del examen
    function view_review() public view teacherOnly(msg.sender) returns (string[] memory){
        return reviewList;
    }

}