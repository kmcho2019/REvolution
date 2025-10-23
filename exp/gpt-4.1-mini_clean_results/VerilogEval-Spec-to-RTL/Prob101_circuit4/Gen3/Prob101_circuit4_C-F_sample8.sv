module TopModule(
    input  a,  // Unused input
    input  b,
    input  c,
    input  d,  // Unused input
    output q
);

// Output q depends only on b and c as q = b OR c.
// Inputs a and d do not affect the output.
assign q = b | c;

endmodule