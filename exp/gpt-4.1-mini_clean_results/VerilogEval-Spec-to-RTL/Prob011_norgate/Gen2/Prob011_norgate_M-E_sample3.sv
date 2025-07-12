module TopModule (
    input  a,
    input  b,
    output out
);

wire not_a;
wire not_b;

not u_not_a (not_a, a);
not u_not_b (not_b, b);
and u_and (out, not_a, not_b);

endmodule