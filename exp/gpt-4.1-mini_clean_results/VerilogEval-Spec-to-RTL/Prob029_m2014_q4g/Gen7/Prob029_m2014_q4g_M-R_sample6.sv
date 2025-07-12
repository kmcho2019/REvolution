module TopModule (
    input  wire in1,
    input  wire in2,
    input  wire in3,
    output wire out
);

    // Compute XNOR using the built-in xnor operator, then XOR with in3
    assign out = (in1 ~^ in2) ^ in3;

endmodule