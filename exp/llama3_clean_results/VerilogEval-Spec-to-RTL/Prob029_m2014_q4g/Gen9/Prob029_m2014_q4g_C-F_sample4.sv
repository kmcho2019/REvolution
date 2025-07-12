module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Direct implementation using XOR and XNOR operations for simplicity and efficiency
assign out = !(in1 ^ in2) ^ in3;

// Alternatively, for educational purposes or specific synthesis constraints,
// the following structural representation can be used:
// 
// wire xnor_out;
// assign xnor_out = (in1 & in2) | ~(in1 | in2);
// assign out = (xnor_out & ~in3) | (~xnor_out & in3);

endmodule