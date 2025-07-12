module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire [1:0] eq_bits;
    
    assign eq_bits[0] = ~(A[0] ^ B[0]);  // XNOR for bit 0
    assign eq_bits[1] = ~(A[1] ^ B[1]);  // XNOR for bit 1
    assign z = eq_bits[0] & eq_bits[1];  // AND of comparison results

endmodule