// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x XOR y)
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module:
// Instantiates two A and two B submodules,
// first pair outputs OR, second pair outputs AND,
// final output is XOR of these two results.
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1_out, b1_out;
    wire a2_out, b2_out;

    A a1 (.x(x), .y(y), .z(a1_out));
    B b1 (.x(x), .y(y), .z(b1_out));
    A a2 (.x(x), .y(y), .z(a2_out));
    B b2 (.x(x), .y(y), .z(b2_out));

    wire or_out = a1_out | b1_out;
    wire and_out = a2_out & b2_out;

    assign z = or_out ^ and_out;
endmodule