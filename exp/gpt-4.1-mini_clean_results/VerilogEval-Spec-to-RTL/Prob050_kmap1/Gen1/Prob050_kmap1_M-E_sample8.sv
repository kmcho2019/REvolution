module TopModule(
    input  a,
    input  b,
    input  c,
    output out
);

    wire nor_out;

    nor nor3(nor_out, a, b, c);
    not not1(out, nor_out);

endmodule