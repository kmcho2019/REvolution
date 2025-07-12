module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits
    parameter integer N = 16          // Total bits including sign and fraction
)(
    input  wire [N-1:0] a,            // First fixed-point operand (two's complement)
    input  wire [N-1:0] b,            // Second fixed-point operand (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Internal registers
    reg [N-1:0] res;                  // result register
    reg sign_a, sign_b, sign_res;
    reg [N-2:0] abs_a, abs_b;         // Absolute values (N-1 bits)
    reg [N-1:0] abs_sum;              // Sum or difference of absolute values (N bits to hold carry)
    reg [N-1:0] abs_diff;

    // Function to get absolute value of two's complement number
    function [N-2:0] abs_val;         // N-1 bits without sign
        input [N-1:0] val;
        reg [N-1:0] neg_val;
    begin
        if (val[N-1] == 1'b1) begin
            // negative: abs = ~val + 1 (two's complement abs)
            neg_val = ~val + 1;
            abs_val = neg_val[N-2:0]; // drop sign bit, keep N-1 bits
        end else begin
            abs_val = val[N-2:0];
        end
    end
    endfunction

    always @(*) begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute absolute values without sign bit
        abs_a = abs_val(a);
        abs_b = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign => addition of absolute values
            abs_sum = {1'b0, abs_a} + {1'b0, abs_b};  // N bits wide to hold carry
            // Keep only N-1 bits (drop carry out)
            // Sign of result = common sign
            sign_res = sign_a;
            // Compose result
            // Handle possible overflow in magnitude by truncation (wrap around)
            res = {sign_res, abs_sum[N-2:0]};
        end else begin
            // Different signs => subtract smaller abs from larger abs
            if (abs_a > abs_b) begin
                abs_diff = {1'b0, abs_a} - {1'b0, abs_b};
                sign_res = sign_a;  // sign of the larger absolute operand (a)
                // If difference zero, clear sign bit to 0 (positive zero)
                if (abs_diff[N-2:0] == 0) begin
                    sign_res = 1'b0;
                end
                res = {sign_res, abs_diff[N-2:0]};
            end else if (abs_b > abs_a) begin
                abs_diff = {1'b0, abs_b} - {1'b0, abs_a};
                sign_res = sign_b;  // sign of the larger absolute operand (b)
                if (abs_diff[N-2:0] == 0) begin
                    sign_res = 1'b0;
                end
                res = {sign_res, abs_diff[N-2:0]};
            end else begin
                // abs_a == abs_b, result zero, sign positive zero
                res = {1'b0, {(N-1){1'b0}}};
            end
        end

        c = res;
    end

endmodule

/*
Notes:

- Inputs 'a' and 'b' are treated as N-bit two's complement fixed-point numbers.
- 'Q' parameter defines fractional bits; not used in logic but indicates fixed-point precision.
- Absolute values are computed manually by inverting and adding 1 when negative.
- When signs match, add magnitudes and keep sign.
- When signs differ, subtract smaller magnitude from larger; sign of result = sign of larger magnitude operand.
- Result zero always positive zero.
- Overflow beyond N-1 bits (excluding sign) truncates (wraps) naturally.
- Output 'c' is always two's complement signed fixed-point number.
- The internal register 'res' is combinational and updated on any input change.
*/