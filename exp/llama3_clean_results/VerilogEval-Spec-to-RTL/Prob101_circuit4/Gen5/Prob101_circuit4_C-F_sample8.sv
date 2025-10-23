module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Simplified logic expression using K-map and logical rules
assign q = b | c;

endmodule