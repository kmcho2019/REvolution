module fixed_point_adder #(
    parameter integer N = 16,      // Total bits including sign bit
    parameter integer Q = 8        // Number of fractional bits (fraction precision)
)(
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement signed)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement signed)
    output reg  [N-1:0] c          // Fixed-point output result (sum with saturation)
);

    // Interpret inputs as signed values
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Perform signed addition, with an extra bit to detect overflow
    wire signed [N:0] sum_ext = {a_signed[N-1], a_signed} + {b_signed[N-1], b_signed};

    // Overflow detection for signed addition:
    // Overflow occurs if the carry into the sign bit differs from the carry out of the sign bit
    // or equivalently if the sign of inputs is the same but differs from sign of result
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire sum_sign = sum_ext[N-1];
    wire overflow = (~(a_sign ^ b_sign)) & (sum_sign ^ a_sign);

    // Saturation constants: max positive and max negative values for N-bit signed numbers
    localparam signed [N-1:0] SAT_POS = {1'b0, {(N-1){1'b1}}};   // Maximum positive (e.g. 0x7FFF)
    localparam signed [N-1:0] SAT_NEG = {1'b1, {(N-1){1'b0}}};   // Maximum negative (most negative) (e.g. 0x8000)

    // Internal signed register to hold result
    reg signed [N-1:0] res;

    always @* begin
        if (overflow) begin
            // Saturate to max positive or max negative on overflow
            if (a_sign == 1'b0) begin
                res = SAT_POS;   // Positive overflow
            end else begin
                res = SAT_NEG;   // Negative overflow
            end
        end else begin
            // No overflow, assign sum lower N bits
            res = sum_ext[N-1:0];
        end
        c = res;
    end

endmodule