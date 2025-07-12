module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly calculate XNOR using fundamental gates and then XOR with in3
assign out = ((in1 & in2) | (~in1 & ~in2)) ^ in3;

endmodule