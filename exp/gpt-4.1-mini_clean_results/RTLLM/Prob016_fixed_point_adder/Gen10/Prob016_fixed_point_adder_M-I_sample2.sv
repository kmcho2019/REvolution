module fixed_point_adder #(
    parameter integer Q = 8,   // Number of fractional bits (precision)
    parameter integer N = 16   // Total number of bits including sign
)(
    input  wire [N-1:0] a,    // Fixed-point input operand A
    input  wire [N-1:0] b,    // Fixed-point input operand B
    output reg  [N-1:0] c     // Fixed-point addition result
);

    // Local signals for sign and magnitude
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values (magnitude) of a and b using two's complement
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    // Compare magnitudes
    wire a_gt_b = (abs_a > abs_b);
    wire abs_eq = (abs_a == abs_b);

    // Internal signals for addition and subtraction results
    wire [N:0] abs_add_ext = {1'b0, abs_a} + {1'b0, abs_b};  // N+1 bits to detect overflow
    wire [N-1:0] abs_sub = a_gt_b ? (abs_a - abs_b) : (abs_b - abs_a);

    // Parameters for saturation limits (max and min representable fixed-point numbers)
    localparam [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};         // Max positive number: sign=0, rest 1's
    localparam [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};         // Min negative number: sign=1, rest 0's (most negative)

    // Variables for the intermediate magnitude and sign
    reg [N-1:0] mag_res;
    reg res_sign;

    always @* begin
        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            // Check overflow: if abs_add_ext[N] (carry out) or result magnitude MSB exceeded
            // Saturate output on overflow
            if (abs_add_ext[N] || (abs_add_ext[N-1] != sign_a)) begin
                // Overflow, saturate
                if (sign_a == 1'b0) begin
                    mag_res = MAX_VAL;
                    res_sign = 1'b0;
                end else begin
                    mag_res = MIN_VAL;
                    res_sign = 1'b1;
                end
            end else begin
                // No overflow, normal result
                mag_res = abs_add_ext[N-1:0];
                res_sign = sign_a;
            end
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (abs_eq) begin
                // Equal magnitudes => result zero (positive zero)
                mag_res = {N{1'b0}};
                res_sign = 1'b0;
            end else begin
                mag_res = abs_sub;
                // sign is sign of the operand with larger magnitude
                res_sign = a_gt_b ? sign_a : sign_b;
            end
        end
    end

    // Convert sign-magnitude back to two's complement signed number
    always @* begin
        if (res_sign == 1'b0) begin
            // positive result
            c = mag_res;
        end else begin
            // negative result: two's complement
            c = (~mag_res) + 1'b1;
        end
    end

endmodule