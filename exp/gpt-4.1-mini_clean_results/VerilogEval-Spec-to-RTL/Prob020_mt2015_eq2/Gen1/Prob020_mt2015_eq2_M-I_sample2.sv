module TopModule(
    input  [1:0] A,
    input  [1:0] B,
    output       z
);
    wire x0 = A[0] ^ B[0];
    wire x1 = A[1] ^ B[1];
    assign z = ~(x0 | x1);
endmodule