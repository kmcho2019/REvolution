module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire diff0, diff1;
    
    // Bitwise comparison using XOR
    assign diff0 = A[0] ^ B[0];
    assign diff1 = A[1] ^ B[1];
    
    // NOR reduction of differences
    assign z = ~(diff0 | diff1);
endmodule