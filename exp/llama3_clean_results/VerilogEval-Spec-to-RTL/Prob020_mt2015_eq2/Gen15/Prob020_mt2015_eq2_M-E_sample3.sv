module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Compare MSBs of A and B
wire msb_equal;
assign msb_equal = (A[1] == B[1]);

// Compare LSBs of A and B
wire lsb_equal;
assign lsb_equal = (A[0] == B[0]);

// Use AND gate to combine MSB and LSB comparison results
wire both_bits_equal;
assign both_bits_equal = msb_equal && lsb_equal;

// Use OR gate to handle case where MSBs are not equal
assign z = both_bits_equal;

endmodule