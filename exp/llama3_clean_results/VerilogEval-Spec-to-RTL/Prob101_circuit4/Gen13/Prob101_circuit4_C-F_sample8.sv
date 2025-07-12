module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Direct OR operation implementation (Example 2)
assign q = b | c;

// Alternative implementation using NOT and AND gates (Example 1)
// assign q = ~(~b & ~c);

endmodule