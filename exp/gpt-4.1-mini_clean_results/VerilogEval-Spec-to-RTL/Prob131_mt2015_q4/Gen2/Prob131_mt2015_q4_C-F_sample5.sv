// Module A: implements z = (x XOR y) AND x
module A(
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: from waveform, z = XNOR(x, y)
module B(
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module: instantiates one A and one B module, reusing their outputs
// Wires from single instances are reused as inputs to OR and AND gates as per specification:
// or_out = A_out OR B_out
// and_out = A_out AND B_out
// z = or_out XOR and_out
module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    wire a_out, b_out;
    wire or_out, and_out;

    // Single instances of A and B
    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    // OR of A and B outputs for first pair
    assign or_out = a_out | b_out;

    // AND of A and B outputs for second pair
    assign and_out = a_out & b_out;

    // XOR of OR and AND results
    assign z = or_out ^ and_out;

endmodule