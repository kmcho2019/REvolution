module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Internal wire to connect XNOR and XOR gates
wire xnor_out;

// Implement XNOR gate using XOR and NOT gates
assign xnor_out = ~(in1 ^ in2);

// Implement XOR gate
assign out = xnor_out ^ in3;

endmodule