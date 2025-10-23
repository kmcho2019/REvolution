module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Intermediate bitwise XNOR and reduction AND showing explicit equality check logic
wire bitwise_eq = &((A[1] ~^ B[1]), (A[0] ~^ B[0]));

// Direct vector equality operator to drive output with clear designer intent
assign z = (A == B);

// synthesis translate_off
// This assertion confirms the equivalence of the two methods during simulation
// assert (z === bitwise_eq) else $error("Mismatch between equality operator and bitwise equality logic");
// synthesis translate_on

endmodule