// Module A implemented with basic gates: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    wire xor_xy;
    xor (xor_xy, x, y);
    and (z, xor_xy, x);
endmodule

// Module B implemented with basic gates matching observed waveform behavior
// From waveform, B outputs z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    wire xor_xy;
    xor (xor_xy, x, y);
    not (z, xor_xy);
endmodule

// Top-level module with explicit gate instantiations combining outputs
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // Instantiate modules A and B twice
    A A1(.x(x), .y(y), .z(a1_out));
    B B1(.x(x), .y(y), .z(b1_out));

    A A2(.x(x), .y(y), .z(a2_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // Explicit gate instantiations for OR and AND gates
    or  or1 (or_out, a1_out, b1_out);
    and and1(and_out, a2_out, b2_out);

    // Explicit XOR gate for final output z
    xor xor1(z, or_out, and_out);
endmodule