module fixed_point_adder #(
    parameter integer N = 16,      // Total bits including sign bit
    parameter integer Q = 8        // Number of fractional bits (not used directly here)
)(
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c          // Fixed-point output result (sum with saturation)
);

    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Sum with one extra bit for overflow detection
    wire signed [N:0] sum_ext = a_signed + b_signed;

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire sum_sign = sum_ext[N-1];

    // Overflow when inputs have same sign but sum sign differs
    wire overflow = (~(a_sign ^ b_sign)) & (sum_sign ^ a_sign);

    // Saturation limits
    localparam signed [N-1:0] SAT_POS = {1'b0, {(N-1){1'b1}}};  // max positive
    localparam signed [N-1:0] SAT_NEG = {1'b1, {(N-1){1'b0}}};  // max negative

    reg signed [N-1:0] res;

    always @* begin
        if (overflow) begin
            res = a_sign ? SAT_NEG : SAT_POS;
        end else begin
            res = sum_ext[N-1:0];
        end
        c = res;
    end

endmodule