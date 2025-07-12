module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

always_comb begin
    // Perform bit-wise equality check using XNOR
    logic eq_bit1, eq_bit0;
    eq_bit1 = ~(A[1] ^ B[1]); // XNOR operation
    eq_bit0 = ~(A[0] ^ B[0]); // XNOR operation
    
    // Combine the results to determine the final output
    z = eq_bit1 & eq_bit0;
end

endmodule