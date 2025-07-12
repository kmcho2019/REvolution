module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits
    parameter integer N = 16          // Total bits including sign
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Interpret inputs as signed values
    wire signed [N-1:0] a_s = a;
    wire signed [N-1:0] b_s = b;

    // Extended addition result with extra MSB for overflow detection
    wire signed [N:0] sum_ext = {a_s[N-1], a_s} + {b_s[N-1], b_s};

    // Truncated sum to N bits
    wire signed [N-1:0] sum_trunc = sum_ext[N-1:0];

    // Overflow detection:
    // Overflow if a and b have the same sign, but sum differs in sign
    wire overflow = (~(a_s[N-1] ^ b_s[N-1])) & (a_s[N-1] ^ sum_trunc[N-1]);

    // Saturation limits
    localparam signed [N-1:0] SAT_POS = {1'b0, {(N-1){1'b1}}};  // max positive number
    localparam signed [N-1:0] SAT_NEG = {1'b1, {(N-1){1'b0}}};  // most negative number

    // Saturated result selection
    wire signed [N-1:0] saturated_result = (a_s[N-1] == 1'b0) ? SAT_POS : SAT_NEG;

    // Final output result with saturation
    assign c = overflow ? saturated_result : sum_trunc;

endmodule