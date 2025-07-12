module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

wire xnor_out;

// Instantiate a two-input XNOR gate using a primitive or user-defined gate
// Since Verilog does not have a built-in XNOR primitive, use xor gate with negation or define a module.
// Here, instantiate xor gate and invert output for XNOR
wire xor_out;
xor u_xor (xor_out, in1, in2);
not u_not (xnor_out, xor_out);

// Instantiate a two-input XOR gate
xor u_xor2 (out, xnor_out, in3);

endmodule