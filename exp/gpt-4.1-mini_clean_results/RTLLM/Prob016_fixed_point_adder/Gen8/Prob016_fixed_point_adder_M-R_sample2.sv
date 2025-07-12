module fixed_point_adder #(
    parameter integer N = 16,      // Total bits including sign bit
    parameter integer Q = 8        // Number of fractional bits (for interface consistency)
)(
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c          // Fixed-point output result (sum with saturation)
);

    // Cast inputs to signed for arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Extended sum to detect overflow (N+1 bits)
    wire signed [N:0] sum_ext = {a_signed[N-1], a_signed} + {b_signed[N-1], b_signed};

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire sum_sign = sum_ext[N-1];

    // Overflow occurs if inputs have same sign but result sign differs
    wire overflow = (~(a_sign ^ b_sign)) & (sum_sign ^ a_sign);

    // Saturation bounds
    localparam signed [N-1:0] SAT_POS = {1'b0, {(N-1){1'b1}}};  // Max positive value
    localparam signed [N-1:0] SAT_NEG = {1'b1, {(N-1){1'b0}}};  // Max negative value

    // Result with saturation applied
    wire signed [N-1:0] res = overflow ? (a_sign ? SAT_NEG : SAT_POS) : sum_ext[N-1:0];

    // Output assignment
    assign c = res;

endmodule