module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Create a signal that represents the XNOR of in1 and in2
wire xnor_out;
assign xnor_out = ~(in1 ^ in2);

// Use a multiplexer to implement the XOR operation
// Select between in3 and the inverse of in3 based on xnor_out
assign out = (xnor_out)? (~in3) : in3;

endmodule