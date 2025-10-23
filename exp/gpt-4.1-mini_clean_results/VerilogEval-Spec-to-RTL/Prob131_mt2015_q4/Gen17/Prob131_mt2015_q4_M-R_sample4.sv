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

// Top-level module with shared A and B instances
// Uses procedural always_comb blocks to compute OR, AND, and XOR
module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);
    wire xor_xy;
    wire inv_xor_xy;

    // Shared signals
    assign xor_xy = x ^ y;
    assign inv_xor_xy = ~xor_xy;

    // Single shared instances of A and B
    wire a_out_shared;
    wire b_out_shared;

    A a_inst (
        .x(x),
        .xor_xy(xor_xy),
        .z(a_out_shared)
    );

    B b_inst (
        .inv_xor_xy(inv_xor_xy),
        .z(b_out_shared)
    );

    // Replicate outputs to create two copies each for logic operations
    wire a_out0 = a_out_shared;
    wire a_out1 = a_out_shared;
    wire b_out0 = b_out_shared;
    wire b_out1 = b_out_shared;

    reg or_out;
    reg and_out;

    // Use always_comb for combinational logic of OR and AND gates
    always @(*) begin
        or_out  = a_out0 | b_out0;
        and_out = a_out1 & b_out1;
    end

    // Compute final output z as XOR of or_out and and_out procedurally
    always @(*) begin
        z = or_out ^ and_out;
    end
endmodule