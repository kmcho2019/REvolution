// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output reg  z
);
    reg xor_xy;
    always @(*) begin
        xor_xy = x ^ y;
        z = xor_xy & x;
    end
endmodule

// Module B: z = XNOR of x and y (z = ~(x ^ y))
module B (
    input  wire x,
    input  wire y,
    output reg  z
);
    reg xor_xy;
    always @(*) begin
        xor_xy = x ^ y;
        z = ~xor_xy;
    end
endmodule

// Top-level module with two instances of A and B, combined as described:
// z = XOR( OR( A1_out, B1_out ), AND( A2_out, B2_out ) )
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1_out, b1_out, a2_out, b2_out;
    wire or_out;
    wire and_out;

    // Instantiate first pair of A and B modules
    A a1 (
        .x(x),
        .y(y),
        .z(a1_out)
    );

    B b1 (
        .x(x),
        .y(y),
        .z(b1_out)
    );

    // Instantiate second pair of A and B modules
    A a2 (
        .x(x),
        .y(y),
        .z(a2_out)
    );

    B b2 (
        .x(x),
        .y(y),
        .z(b2_out)
    );

    // OR gate combining outputs of first A and B instances
    assign or_out = a1_out | b1_out;

    // AND gate combining outputs of second A and B instances
    assign and_out = a2_out & b2_out;

    // Final XOR gate combining OR and AND results
    assign z = or_out ^ and_out;
endmodule