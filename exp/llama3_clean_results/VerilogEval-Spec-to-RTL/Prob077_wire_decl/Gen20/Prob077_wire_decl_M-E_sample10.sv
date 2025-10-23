module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    reg out_reg;

    always @(*)
        out_reg = (a & b) | (c & d);

    assign out = out_reg;
    assign out_n = ~out_reg;
endmodule