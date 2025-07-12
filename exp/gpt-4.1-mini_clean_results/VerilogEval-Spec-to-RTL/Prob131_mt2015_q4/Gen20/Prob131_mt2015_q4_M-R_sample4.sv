// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    assign xor_xy = x ^ y;
    assign z = xor_xy & x;
endmodule

// Module B: z = ~(x XOR y)
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module with explicit submodule instances and gate logic
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Instantiate first A and B modules
    wire a0_out, b0_out;
    A  a0 (.x(x), .y(y), .z(a0_out));
    B  b0 (.x(x), .y(y), .z(b0_out));

    // Instantiate second A and B modules
    wire a1_out, b1_out;
    A  a1 (.x(x), .y(y), .z(a1_out));
    B  b1 (.x(x), .y(y), .z(b1_out));

    // Compute OR of first pair outputs
    wire or_out = a0_out | b0_out;
    // Compute AND of second pair outputs
    wire and_out = a1_out & b1_out;

    // Final output: XOR of or_out and and_out
    assign z = or_out ^ and_out;
endmodule