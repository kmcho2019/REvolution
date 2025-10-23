module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

assign out = ~(in1 ^ in2) ^ in3;

// Alternatively, using the logical equality operator (==) for XNOR
// assign out = (in1 == in2) ^ in3;

endmodule