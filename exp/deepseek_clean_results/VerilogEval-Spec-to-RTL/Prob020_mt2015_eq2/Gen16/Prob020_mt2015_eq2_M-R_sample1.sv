module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire eq_bit0, eq_bit1;
    
    // Compare each bit pair
    xnor xnor0(eq_bit0, A[0], B[0]);
    xnor xnor1(eq_bit1, A[1], B[1]);
    
    // Combine results
    and and0(z, eq_bit0, eq_bit1);
endmodule