module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire xor_out1, xor_out2;
    wire and_out1, and_out2;

    assign xor_out1 = a ^ b;
    assign xor_out2 = c ^ d;
    assign and_out1 = ~xor_out1;
    assign and_out2 = ~xor_out2;
    assign out = ~(and_out1 & and_out2);
    assign out_n = ~out;
endmodule