module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Output is 1 if an odd number of inputs are 1
    assign out = a ^ b ^ c ^ d;
endmodule