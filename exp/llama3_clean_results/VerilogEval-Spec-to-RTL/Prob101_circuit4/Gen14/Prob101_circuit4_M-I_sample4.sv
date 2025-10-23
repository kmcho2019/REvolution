module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Directly implementing OR using a single OR gate
assign q = b | c;

endmodule