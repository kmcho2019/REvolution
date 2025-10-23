module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output wire [N-1:0] c             // Fixed-point addition result with saturation (two's complement)
);

    // Internal register for sum (N bits)
    reg [N-1:0] res;

    // Sign bits of operands and result
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    wire sign_res;                     // Sign bit of raw sum before saturation

    // Raw sum before saturation
    wire [N-1:0] sum = a + b;
    assign sign_res = sum[N-1];

    // Detect overflow:
    // Overflow occurs if sign_a == sign_b and sign_res != sign_a
    wire overflow = (sign_a == sign_b) && (sign_res != sign_a);

    // Maximum and minimum fixed-point values (saturation limits)
    localparam [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};          // 0 followed by all 1s (max positive)
    localparam [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};          // 1 followed by all 0s (max negative)

    always @(*) begin
        if (!overflow) begin
            // No overflow, normal sum
            res = sum;
        end else begin
            // Overflow: saturate output
            if (sign_a == 1'b0) 
                res = MAX_VAL;       // Positive overflow saturate to max positive
            else 
                res = MIN_VAL;       // Negative overflow saturate to max negative
        end
    end

    // Output result
    assign c = res;

endmodule