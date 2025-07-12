module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Output is parity of inputs (XOR of all), which matches the Karnaugh map exactly.
    assign out = a ^ b ^ c ^ d;
endmodule