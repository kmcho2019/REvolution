module fixed_point_adder #(
    parameter integer N = 16,      // Total bits including sign bit
    parameter integer Q = 8        // Number of fractional bits (not directly used here but defines fixed point format)
)(
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c          // Fixed-point output result (sum with saturation)
);

    // Interpret inputs as signed values
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Signed addition with one extra bit for detecting overflow
    wire signed [N:0] sum_ext = a_signed + b_signed;

    // Overflow detection:
    // Overflow occurs if the sign of inputs are the same but differs from sign of sum
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire sum_sign = sum_ext[N-1];
    wire overflow = (~(a_sign ^ b_sign)) & (sum_sign ^ a_sign);

    // Saturation values (max positive and max negative numbers)
    localparam signed [N-1:0] SAT_POS = {1'b0, {(N-1){1'b1}}};           // 0x7FFF.. max positive
    localparam signed [N-1:0] SAT_NEG = {1'b1, {(N-1){1'b0}}};           // 0x8000.. max negative (most negative number)

    // Internal register to hold the result
    reg signed [N-1:0] res;

    always @* begin
        if (overflow) begin
            // Saturate on overflow
            if (a_sign == 1'b0) begin
                // Overflow on positive overflow: clamp to max positive
                res = SAT_POS;
            end else begin
                // Overflow on negative overflow: clamp to max negative
                res = SAT_NEG;
            end
        end else begin
            // No overflow: just assign lower N bits of sum
            res = sum_ext[N-1:0];
        end
    end

    // Assign output
    always @* begin
        c = res;
    end

endmodule