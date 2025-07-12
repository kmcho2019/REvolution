// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = XNOR of x and y (z = ~(x ^ y))
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module implementing:
// z = XOR( OR( A_out, B_out ), AND( A_out, B_out ) )
// Where A_out = A(x,y), B_out = B(x,y)
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a_out;
    wire b_out;
    wire or_out;
    wire and_out;

    // Single instances of A and B modules
    A a_inst (
        .x(x),
        .y(y),
        .z(a_out)
    );

    B b_inst (
        .x(x),
        .y(y),
        .z(b_out)
    );

    // Compute OR and AND of A and B outputs
    assign or_out  = a_out | b_out;
    assign and_out = a_out & b_out;

    // Final output is XOR of OR and AND results
    assign z = or_out ^ and_out;
endmodule