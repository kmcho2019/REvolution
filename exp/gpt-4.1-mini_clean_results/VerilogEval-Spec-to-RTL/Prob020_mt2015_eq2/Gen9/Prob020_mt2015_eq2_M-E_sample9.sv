module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire diff0;
wire diff1;
wire any_diff;

assign diff0    = A[0] ^ B[0];  // XOR for bit 0
assign diff1    = A[1] ^ B[1];  // XOR for bit 1
assign any_diff = diff0 | diff1; // OR both XOR results

assign z = ~any_diff;           // If any_diff is 0, z=1 (A == B)

endmodule