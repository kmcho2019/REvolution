module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);
    // Direct comparison for simplicity and efficiency
    assign z = (A[1] == B[1]) && (A[0] == B[0]);
    
    // Alternatively, using bitwise XOR for flexibility and potential optimization
    // wire [1:0] xor_result = A ^ B;
    // assign z = ~(xor_result[1] | xor_result[0]);
endmodule