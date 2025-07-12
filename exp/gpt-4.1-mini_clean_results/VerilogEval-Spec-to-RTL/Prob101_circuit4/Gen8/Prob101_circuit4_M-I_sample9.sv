module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,    // d is unused
    output wire q
);

assign q = b | c;

endmodule