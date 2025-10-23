// Module A: z = (x ^ y) & x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: Behavior from waveform, implemented as LUT by case statement
// Here we implement B using a lookup based on (x,y) per the waveform pattern
// For synthesis, a simple combinational logic that matches the waveform is provided.
// B's output is 1 for (x,y): 00, 11; and 0 otherwise.
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    // From waveform observation:
    // z=1 when (x,y) == (0,0) or (1,1), else 0
    // So B = ~(x ^ y)
    assign z = ~(x ^ y);
endmodule

// 2:1 Multiplexer module
module Mux2to1 (
    input  wire sel,
    input  wire in0,
    input  wire in1,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

// Top-level module instantiates two A and two B submodules
// Uses two multiplexers controlled by x and y respectively
// XORs the two mux outputs to produce final z
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a_out1, a_out2;
    wire b_out1, b_out2;

    // Instantiate first pair of submodules
    A a1(.x(x), .y(y), .z(a_out1));
    B b1(.x(x), .y(y), .z(b_out1));

    // Instantiate second pair of submodules
    A a2(.x(x), .y(y), .z(a_out2));
    B b2(.x(x), .y(y), .z(b_out2));

    // Multiplexers controlled by x and y respectively
    wire mux_out1, mux_out2;

    Mux2to1 mux1(.sel(x), .in0(a_out1), .in1(b_out1), .out(mux_out1));
    Mux2to1 mux2(.sel(y), .in0(a_out2), .in1(b_out2), .out(mux_out2));

    // Final XOR of mux outputs
    assign z = mux_out1 ^ mux_out2;
endmodule