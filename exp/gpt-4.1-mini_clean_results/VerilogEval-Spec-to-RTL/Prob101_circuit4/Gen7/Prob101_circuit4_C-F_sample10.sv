module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

// Combinational logic: output q is high when either input b or c is high
assign q = b | c;

endmodule