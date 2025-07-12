module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire diff0, diff1;
    
    assign diff0 = A[0] ^ B[0];  // XOR for bit 0 comparison
    assign diff1 = A[1] ^ B[1];  // XOR for bit 1 comparison
    assign z = ~(diff0 | diff1); // NOR to check if all bits are equal

endmodule