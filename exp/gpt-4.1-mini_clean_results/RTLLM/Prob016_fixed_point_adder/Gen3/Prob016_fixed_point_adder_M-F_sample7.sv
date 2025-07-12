module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold result
    reg [N-1:0] res;

    // Internal signed representations
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Temporary variables for absolute values and intermediate calculations
    reg [N-1:0] a_abs;
    reg [N-1:0] b_abs;
    reg [N-1:0] abs_diff;
    reg        diff_sign;
    reg signed [N-1:0] diff_result;
    reg signed [N-1:0] sum;
    reg        same_sign;

    always @(*) begin
        // Compute absolute values manually (two's complement if negative)
        if (a_signed[N-1] == 1'b1)
            a_abs = (~a_signed) + 1;
        else
            a_abs = a_signed;

        if (b_signed[N-1] == 1'b1)
            b_abs = (~b_signed) + 1;
        else
            b_abs = b_signed;

        // Check if signs are equal
        same_sign = (a_signed[N-1] == b_signed[N-1]);

        if (same_sign) begin
            // If signs are same, add signed operands directly
            sum = a_signed + b_signed;
            res = sum;
        end else begin
            // Signs differ, perform subtraction of absolute values
            if (a_abs >= b_abs) begin
                abs_diff = a_abs - b_abs;
                diff_sign = a_signed[N-1]; // sign of operand with larger abs (a)
            end else begin
                abs_diff = b_abs - a_abs;
                diff_sign = b_signed[N-1]; // sign of operand with larger abs (b)
            end

            if (abs_diff == 0) begin
                // Result is zero, sign bit zero
                diff_result = {N{1'b0}};
            end else if (diff_sign == 1'b1) begin
                // Negative result: two's complement negate abs_diff
                diff_result = -$signed(abs_diff);
            end else begin
                // Positive result
                diff_result = $signed(abs_diff);
            end

            res = diff_result;
        end
    end

    // Assign the internal register to output
    always @(*) begin
        c = res;
    end

endmodule