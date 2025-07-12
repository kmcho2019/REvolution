module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly perform XNOR between in1 and in2, then XOR with in3
assign out = ~(in1 ^ in2) ^ in3;

endmodule