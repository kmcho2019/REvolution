module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Alternative implementation: output is 1 when row and column XOR patterns match
    assign out = (a ^ b) == (c ^ d);
endmodule