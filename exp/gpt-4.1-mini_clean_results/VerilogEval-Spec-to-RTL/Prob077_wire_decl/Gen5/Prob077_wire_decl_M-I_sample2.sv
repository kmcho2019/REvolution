module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_ab, and_cd;

// Two AND gate primitives for the first layer
and (and_ab, a, b);
and (and_cd, c, d);

// One OR gate primitive for the second layer, driving out
or  (out, and_ab, and_cd);

// One NOT gate primitive generating out_n from out
not (out_n, out);

endmodule