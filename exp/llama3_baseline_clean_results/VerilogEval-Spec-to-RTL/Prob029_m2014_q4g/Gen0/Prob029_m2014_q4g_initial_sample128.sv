module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// First, implement the XNOR gate using XOR and inversion
wire xnor_out;
assign xnor_out = ~(in1 ^ in2);

// Then, connect the output of the XNOR gate to one input of the XOR gate
assign out = xnor_out ^ in3;

endmodule