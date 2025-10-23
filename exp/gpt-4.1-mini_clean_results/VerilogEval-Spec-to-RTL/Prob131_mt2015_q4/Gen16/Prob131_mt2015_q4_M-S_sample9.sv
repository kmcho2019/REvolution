// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire xor_xy,
    output wire z
);
    assign z = xor_xy & x;
endmodule

// Module B: z = ~(x XOR y)
module B (
    input  wire inv_xor_xy,
    output wire z
);
    assign z = inv_xor_xy;
endmodule

// Top-level simplified module
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy = x ^ y;
    wire inv_xor_xy = ~xor_xy;

    wire a_out; // output of A
    wire b_out; // output of B

    A a_inst (
        .x(x),
        .xor_xy(xor_xy),
        .z(a_out)
    );

    B b_inst (
        .inv_xor_xy(inv_xor_xy),
        .z(b_out)
    );

    // OR and AND gates as in original logic but using same outputs twice
    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;

    assign z = or_out ^ and_out;
endmodule