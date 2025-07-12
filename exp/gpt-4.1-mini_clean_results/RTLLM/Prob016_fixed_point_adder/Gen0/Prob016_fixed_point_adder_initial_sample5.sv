module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits
    parameter integer N = 16     // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register for result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract absolute values (clear MSB)
    wire [N-2:0] a_abs = a[N-2:0];
    wire [N-2:0] b_abs = b[N-2:0];

    // Temporary result variables for addition/subtraction without sign bit
    reg [N-1:0] sum_abs;       // To hold addition result of absolute values (including carry)
    reg [N-2:0] diff_abs;      // To hold subtraction result of absolute values (no sign bit)
    reg        diff_sign;      // Sign of difference in subtraction

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            sum_abs = {1'b0, a_abs} + {1'b0, b_abs};  // one extra bit for carry

            // Handle overflow: if sum_abs[N-1] == 1, it means overflow in magnitude (ignored, clipped)
            // Result sign is same as inputs' sign
            res[N-1] = a_sign;

            // Assign magnitude bits - truncate carry if any, clip MSB
            if (sum_abs[N-1]) begin
                // Overflow occurred; clip to max magnitude
                res[N-2:0] = { (N-1){1'b1} }; // saturate to max positive or negative magnitude (all ones)
            end else begin
                res[N-2:0] = sum_abs[N-2:0];
            end
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_abs >= b_abs) begin
                diff_abs = a_abs - b_abs;
                diff_sign = a_sign; // sign of a since |a| >= |b|
            end else begin
                diff_abs = b_abs - a_abs;
                diff_sign = b_sign; // sign of b
            end

            // If result is zero, sign bit set to 0 (positive)
            if (diff_abs == 0) begin
                res[N-1] = 1'b0;
            end else begin
                res[N-1] = diff_sign;
            end
            res[N-2:0] = diff_abs;
        end

        c = res;
    end

endmodule