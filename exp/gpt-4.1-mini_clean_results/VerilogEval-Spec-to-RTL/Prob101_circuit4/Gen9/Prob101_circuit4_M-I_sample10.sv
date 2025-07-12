module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,    // d is unused for this implementation
    output wire q
);

assign q = b | c;

endmodule