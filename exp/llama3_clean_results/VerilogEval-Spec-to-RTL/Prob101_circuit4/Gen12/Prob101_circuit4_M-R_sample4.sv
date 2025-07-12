module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Implementing OR using NAND gates directly
assign q = ~(~b & ~c);

endmodule