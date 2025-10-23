module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Using a single OAI gate to combine AND and OR operations
oai22 oai1 (out, a, b, c, d);
not not1 (out_n, out);

endmodule