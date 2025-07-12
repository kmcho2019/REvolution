module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire [1:0] eq_bits;
    
    // Bitwise comparison using XNOR
    assign eq_bits[0] = ~(A[0] ^ B[0]);
    assign eq_bits[1] = ~(A[1] ^ B[1]);
    
    // Final AND operation
    assign z = eq_bits[0] & eq_bits[1];

endmodule