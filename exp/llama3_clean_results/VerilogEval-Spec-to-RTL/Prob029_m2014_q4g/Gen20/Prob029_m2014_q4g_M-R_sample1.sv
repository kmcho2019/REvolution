// TopModule with inlined XNOR and XOR operations
module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly implement XNOR and XOR operations within TopModule
assign out = ~(in1 ^ in2) ^ in3;

endmodule