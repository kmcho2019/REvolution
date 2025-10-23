module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire x1, x2;

    assign x1 = a ^ b;
    assign x2 = c ^ d;
    assign out = x1 ^ x2;

endmodule