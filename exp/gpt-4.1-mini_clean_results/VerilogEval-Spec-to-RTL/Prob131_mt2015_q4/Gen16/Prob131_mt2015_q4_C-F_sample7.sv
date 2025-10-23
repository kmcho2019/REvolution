// Module A: z = (x ^ y) & x, continuous assign for combinational logic
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: waveform behavior corresponds to z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module instantiating two separate A and B modules each,
// outputs combined by OR and AND gates, then XORed for final output.
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // First pair of A and B modules
    A A1(.x(x), .y(y), .z(a1_out));
    B B1(.x(x), .y(y), .z(b1_out));

    // Second pair of A and B modules
    A A2(.x(x), .y(y), .z(a2_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // OR gate for first pair outputs
    assign or_out = a1_out | b1_out;

    // AND gate for second pair outputs
    assign and_out = a2_out & b2_out;

    // XOR gate combining OR and AND outputs to produce top-level z
    assign z = or_out ^ and_out;
endmodule