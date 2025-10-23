module TopModule(
    input  [1:0] A,
    input  [1:0] B,
    output       z
);
    wire eq_msb, eq_lsb;
    assign eq_msb = ~(A[1] ^ B[1]);
    assign eq_lsb = ~(A[0] ^ B[0]);
    assign z = eq_msb & eq_lsb;
endmodule