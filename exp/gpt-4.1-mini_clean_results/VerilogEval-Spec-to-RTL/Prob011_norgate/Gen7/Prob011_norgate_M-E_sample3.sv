module TopModule (
    input  a,
    input  b,
    output out
);

wire or_out;

or u_or (or_out, a, b);
not u_not (out, or_out);

endmodule