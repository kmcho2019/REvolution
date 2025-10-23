module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Inlined OR operation to reduce area and power consumption
assign q = b | c;

endmodule