module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out; // internal wire for XNOR output

// XNOR gate implementation
assign xnor_out = ~(in1 ^ in2);

// XOR gate implementation
assign out = xnor_out ^ in3;

endmodule