module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Output is high when the parity of (a,b) differs from parity of (c,d)
    assign out = (a ^ b) ^ (c ^ d);
endmodule