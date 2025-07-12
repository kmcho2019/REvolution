module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out;

// Use the equality operator to implement XNOR function concisely and clearly
assign xnor_out = (in1 == in2);

// Instantiate a two-input XOR gate primitive for the second stage
xor u_xor (out, xnor_out, in3);

endmodule