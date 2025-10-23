// XNOR_module
module XNOR_module(
    input a,
    input b,
    output out
);

assign out = ~(a ^ b);

endmodule

// XOR_module
module XOR_module(
    input a,
    input b,
    output out
);

assign out = a ^ b;

endmodule

// TopModule
module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

wire xnor_out;

XNOR_module xnor_instance(
    .a(in1),
    .b(in2),
    .out(xnor_out)
);

// Directly use the XOR operation in the TopModule for efficiency
assign out = xnor_out ^ in3;

endmodule