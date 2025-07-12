module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire eq0, eq1;
    
    // Bit-wise comparison using XNOR gates
    xnor xnor0(eq0, A[0], B[0]);
    xnor xnor1(eq1, A[1], B[1]);
    
    // Final AND gate to combine comparison results
    and and0(z, eq0, eq1);
endmodule