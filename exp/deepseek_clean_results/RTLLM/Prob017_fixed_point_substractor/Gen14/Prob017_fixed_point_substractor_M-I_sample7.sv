module fixed_point_subtractor #(
    parameter Q = 16,        // Number of fractional bits (must be 0 < Q < N)
    parameter N = 32         // Total bit width (must be N > 1)
) (
    input wire signed [N-1:0] a,    // First fixed-point operand (Q.N format)
    input wire signed [N-1:0] b,    // Second fixed-point operand
    output reg signed [N-1:0] c     // Subtraction result with saturation
);

    // Internal signals
    wire signed [N-1:0] sub_result;
    wire overflow_positive, overflow_negative;

    // Core subtraction operation
    assign sub_result = a - b;

    // Overflow detection
    assign overflow_positive = ~a[N-1] & b[N-1] & sub_result[N-1];  // a - (-b) overflow
    assign overflow_negative = a[N-1] & ~b[N-1] & ~sub_result[N-1];  // (-a) - b underflow

    // Saturation logic
    always @(*) begin
        case ({overflow_positive, overflow_negative})
            2'b10: c = {1'b0, {(N-1){1'b1}}};  // Saturate to max positive
            2'b01: c = {1'b1, {(N-1){1'b0}}};  // Saturate to max negative
            default: c = sub_result;            // Normal operation
        endcase
    end

endmodule