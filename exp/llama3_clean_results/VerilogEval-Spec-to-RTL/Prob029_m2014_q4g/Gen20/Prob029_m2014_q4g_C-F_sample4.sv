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

XOR_module xor_instance(
   .a(xnor_out),
   .b(in3),
   .out(out)
);

endmodule