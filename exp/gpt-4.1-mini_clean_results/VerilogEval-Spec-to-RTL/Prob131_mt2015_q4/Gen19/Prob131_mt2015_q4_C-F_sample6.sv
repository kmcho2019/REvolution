module A (
    input  wire x,
    input  wire xor_xy,
    output wire z
);
    // z = (x XOR y) & x; here xor_xy = x ^ y
    assign z = xor_xy & x;
endmodule

module B (
    input  wire inv_xor_xy,
    output wire z
);
    // z = ~(x ^ y); inv_xor_xy = ~(x ^ y)
    assign z = inv_xor_xy;
endmodule

module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Shared intermediate signals
    wire xor_xy = x ^ y;
    wire inv_xor_xy = ~xor_xy;

    // Outputs of A and B modules - 2 instances each
    wire [1:0] a_out;
    wire [1:0] b_out;

    genvar i;
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_A
            A a_inst (
                .x(x),
                .xor_xy(xor_xy),
                .z(a_out[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_B
            B b_inst (
                .inv_xor_xy(inv_xor_xy),
                .z(b_out[i])
            );
        end
    endgenerate

    // First pair (A[0], B[0]) to OR gate
    wire or_out = a_out[0] | b_out[0];
    // Second pair (A[1], B[1]) to AND gate
    wire and_out = a_out[1] & b_out[1];

    // Final output: XOR of OR and AND
    assign z = or_out ^ and_out;
endmodule