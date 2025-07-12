module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Using bitwise operators for potential synthesis optimization
assign out = a | (~a & ~b & c);

endmodule