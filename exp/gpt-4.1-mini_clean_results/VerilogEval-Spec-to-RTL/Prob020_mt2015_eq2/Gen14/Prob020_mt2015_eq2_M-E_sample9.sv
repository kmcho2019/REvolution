module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Bit 0 XNOR using basic gates
wire a0_and_b0 = A[0] & B[0];
wire nota0 = ~A[0];
wire notb0 = ~B[0];
wire nota0_and_notb0 = nota0 & notb0;
wire xnor0 = a0_and_b0 | nota0_and_notb0;

// Bit 1 XNOR using basic gates
wire a1_and_b1 = A[1] & B[1];
wire nota1 = ~A[1];
wire notb1 = ~B[1];
wire nota1_and_notb1 = nota1 & notb1;
wire xnor1 = a1_and_b1 | nota1_and_notb1;

// Both bits must be equal
assign z = xnor0 & xnor1;

endmodule