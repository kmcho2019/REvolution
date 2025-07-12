module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and0_out, and1_out;

    and and0(and0_out, a, b);
    and and1(and1_out, c, d);
    or  or0(out, and0_out, and1_out);
    not not0(out_n, out);

endmodule