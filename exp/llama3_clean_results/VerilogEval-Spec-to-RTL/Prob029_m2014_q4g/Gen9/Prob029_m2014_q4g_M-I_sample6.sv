module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

assign out = (~in3 & (in1 == in2)) | (in3 & (in1 != in2));

// Alternatively, expressing the logic using XOR and XNOR gates explicitly might 
// provide a more intuitive understanding of the circuit but would likely result in 
// similar or identical synthesis outcomes given modern synthesis tools' ability to 
// optimize logical expressions.
// assign xnor_out = ~(in1 ^ in2);
// assign out = xnor_out ^ in3;

endmodule