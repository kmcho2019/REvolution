module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Internal variables for sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Internal magnitude signals: N-1 bits unsigned absolute values
    reg [N-2:0] mag_a;
    reg [N-2:0] mag_b;

    // Intermediate results
    reg [N-1:0] mag_sum;    // Can be N bits to hold carry out
    reg [N-1:0] mag_diff;

    reg        res_sign;
    reg [N-2:0] res_mag;    // magnitude of result (N-1 bits)

    // Combinational block for magnitude extraction and conditional operations
    always @(*) begin
        // Absolute value calculation for a
        if (sign_a)
            mag_a = (~a[N-2:0]) + 1'b1;
        else
            mag_a = a[N-2:0];

        // Absolute value calculation for b
        if (sign_b)
            mag_b = (~b[N-2:0]) + 1'b1;
        else
            mag_b = b[N-2:0];

        if (sign_a == sign_b) begin
            // Same signs: add magnitudes
            mag_sum = {1'b0, mag_a} + {1'b0, mag_b};
            // Assign result sign same as inputs
            res_sign = sign_a;
            // Result magnitude is lower N-1 bits of sum (overflow truncated)
            res_mag = mag_sum[N-2:0];
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (mag_a >= mag_b) begin
                mag_diff = {1'b0, mag_a} - {1'b0, mag_b};
                res_sign = sign_a;  // sign of larger magnitude operand
                res_mag = mag_diff[N-2:0];
            end else begin
                mag_diff = {1'b0, mag_b} - {1'b0, mag_a};
                res_sign = sign_b;  // sign of larger magnitude operand
                res_mag = mag_diff[N-2:0];
            end
        end

        // If result magnitude is zero, sign should be positive (0)
        if (res_mag == 0)
            res_sign = 1'b0;

        // Reconstruct two's complement result from sign and magnitude
        if (res_sign) begin
            c = {1'b1, (~res_mag + 1'b1)};
        end else begin
            c = {1'b0, res_mag};
        end
    end

endmodule