// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: deduced from waveform as XNOR function
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module with two instances each of A and B,
// directly using continuous assignments and inline logic expressions
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;

    // Instantiate two instances of A
    A a1(.x(x), .y(y), .z(a1_out));
    A a2(.x(x), .y(y), .z(a2_out));

    // Instantiate two instances of B
    B b1(.x(x), .y(y), .z(b1_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // Compute final output z by inlining OR and AND operations:
    // z = ((a1_out | b1_out) ^ (a2_out & b2_out));
    assign z = ((a1_out | b1_out) ^ (a2_out & b2_out));
endmodule