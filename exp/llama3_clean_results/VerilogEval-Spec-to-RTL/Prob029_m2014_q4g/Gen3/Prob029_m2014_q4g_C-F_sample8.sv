module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Explicit XNOR representation using bitwise NOT and equality operators
assign out = ~(in1 ^ in2) ^ in3;

endmodule