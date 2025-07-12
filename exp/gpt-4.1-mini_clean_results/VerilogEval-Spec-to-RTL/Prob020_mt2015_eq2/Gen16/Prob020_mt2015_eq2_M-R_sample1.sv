module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire xnor0 = ~(A[0] ^ B[0]);
wire xnor1 = ~(A[1] ^ B[1]);

assign z = xnor0 & xnor1;

endmodule