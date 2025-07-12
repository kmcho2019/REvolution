module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly use the XNOR operator (~^) to simplify the implementation
// and then apply the XOR operator (^) with 'in3'
assign out = ~(in1 ^ in2) ^ in3;

endmodule