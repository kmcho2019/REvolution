module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Implementing OR using a MUX
wire or_bc;
assign or_bc = b | c;
assign q = or_bc;

endmodule