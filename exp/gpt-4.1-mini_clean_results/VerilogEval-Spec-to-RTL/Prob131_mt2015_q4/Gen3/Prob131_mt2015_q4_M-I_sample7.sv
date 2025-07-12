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

// Top-level module: instantiates two A and two B modules as per specification
// Connections:
//  or_out = A1_out OR B1_out
//  and_out = A2_out AND B2_out
//  z = or_out XOR and_out
module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate first A and B
    A a1(.x(x), .y(y), .z(a1_out));
    B b1(.x(x), .y(y), .z(b1_out));

    // Instantiate second A and B
    A a2(.x(x), .y(y), .z(a2_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // OR gate for first pair outputs
    assign or_out = a1_out | b1_out;

    // AND gate for second pair outputs
    assign and_out = a2_out & b2_out;

    // XOR gate combines the OR and AND outputs
    assign z = or_out ^ and_out;

endmodule