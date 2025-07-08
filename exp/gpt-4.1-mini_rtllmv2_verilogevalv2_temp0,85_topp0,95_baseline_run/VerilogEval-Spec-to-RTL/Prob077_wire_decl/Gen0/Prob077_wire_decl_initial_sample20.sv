module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    wire and1_out;
    wire and2_out;

    and u_and1 (and1_out, a, b);
    and u_and2 (and2_out, c, d);
    or  u_or   (out, and1_out, and2_out);
    not u_not  (out_n, out);

endmodule