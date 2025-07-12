module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out;

// Implement XNOR operation
assign xnor_out = ~(in1 ^ in2);

// Implement XOR operation with 'in3'
assign out = xnor_out ^ in3;

endmodule