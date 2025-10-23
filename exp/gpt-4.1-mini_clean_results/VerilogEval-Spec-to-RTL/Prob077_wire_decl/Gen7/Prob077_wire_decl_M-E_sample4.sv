module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and1_out;
    wire and2_out;

    // AND gate for inputs a and b
    and u_and1 (and1_out, a, b);

    // AND gate for inputs c and d
    and u_and2 (and2_out, c, d);

    // OR gate combining outputs of the AND gates
    or  u_or (out, and1_out, and2_out);

    // NOT gate generating out_n as inversion of out
    not u_not (out_n, out);

endmodule