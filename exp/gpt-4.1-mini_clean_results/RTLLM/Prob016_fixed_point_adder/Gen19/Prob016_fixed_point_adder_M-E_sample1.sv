module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total width including sign bit
)(
    input  wire [N-1:0] a,      // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,      // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c       // Fixed-point output result (two's complement)
);

    // Intermediate wider sum to detect overflow
    wire signed [N:0] sum_ext;
    assign sum_ext = $signed(a) + $signed(b);

    // Maximum and minimum representable fixed-point numbers for saturation
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};     // Max positive: 0 followed by all ones
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};     // Min negative: 1 followed by all zeros

    // Check for overflow:
    // Overflow occurs if sign of a and b are same but sign of sum_ext differs.
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    wire sign_sum = sum_ext[N];

    wire overflow = (~(sign_a ^ sign_b)) & (sign_a ^ sign_sum);

    always @(*) begin
        if (overflow) begin
            // Saturate to max or min based on input sign
            if (sign_a == 1'b0) begin
                // Positive overflow, saturate to max positive
                c = MAX_VAL;
            end else begin
                // Negative overflow, saturate to min negative
                c = MIN_VAL;
            end
        end else begin
            // No overflow, assign lower N bits of sum
            c = sum_ext[N-1:0];
        end
    end

endmodule