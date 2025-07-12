module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire or1_out, or2_out;

// OR gate for (a or b)
or or1 (or1_out, a, b);

// OR gate for (c or d)
or or2 (or2_out, c, d);

// AND gate for (or1_out and or2_out)
and and1 (q, or1_out, or2_out);

endmodule