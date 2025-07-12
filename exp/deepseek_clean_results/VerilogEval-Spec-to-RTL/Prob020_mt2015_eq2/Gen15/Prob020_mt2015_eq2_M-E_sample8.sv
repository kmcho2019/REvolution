module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire [1:0] eq_bits;
    
    assign eq_bits = A ~^ B;  // Bitwise XNOR
    assign z = &eq_bits;      // Reduction AND
endmodule