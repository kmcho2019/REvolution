module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire or1_out, or2_out;

    or u_or1 (or1_out, a, b);
    or u_or2 (or2_out, c, d);
    and u_and1 (q, or1_out, or2_out);

endmodule