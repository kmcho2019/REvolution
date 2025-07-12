module fixed_point_adder #(
    parameter integer Q = 8,            // Number of fractional bits
    parameter integer N = 16            // Total bits including sign
)(
    input  wire [N-1:0] a,              // Fixed-point operand a (signed two's complement)
    input  wire [N-1:0] b,              // Fixed-point operand b (signed two's complement)
    output reg  [N-1:0] c               // Fixed-point result
);

    // Internal signals: extend magnitude by 1 bit for overflow detection
    reg sign_a, sign_b, sign_res;
    reg [N-2:0] abs_a_raw, abs_b_raw;              // Magnitudes without sign
    reg [N-1:0] abs_a_ext, abs_b_ext;               // Magnitudes extended by 1 bit
    reg [N:0] abs_sum;                              // Sum can be N+1 bits wide
    reg [N-1:0] abs_diff;
    reg abs_a_ge_b;
    reg overflow;
    reg [N-1:0] max_pos, max_neg;

    // Function to get absolute magnitude (N-1 bits) from two's complement input
    function [N-2:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0)
                abs_val = val[N-2:0];
            else
                abs_val = (~val[N-2:0] + 1'b1);
        end
    endfunction

    // Prepare saturation limits
    // max positive number: sign=0, magnitude all 1s
    // max negative number: sign=1, magnitude 1 followed by 0s (two's complement min)
    // For saturated positive max, magnitude max = 2^(N-1)-1
    // For saturated negative max, min is -2^(N-1) in two's complement (sign=1, magnitude zero)
    // Here max_neg is 100..0 (most negative number)
    // max_pos is 0 111..1 (max positive)
    always @* begin
        max_pos = {1'b0, {(N-1){1'b1}}};
        max_neg = {1'b1, {(N-1){1'b0}}};
    end

    always @* begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];
        abs_a_raw = abs_val(a);
        abs_b_raw = abs_val(b);

        // Extend abs magnitudes by one bit for addition overflow detection
        abs_a_ext = {1'b0, abs_a_raw};
        abs_b_ext = {1'b0, abs_b_raw};

        overflow = 1'b0;
        abs_a_ge_b = (abs_a_raw >= abs_b_raw);

        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            abs_sum = abs_a_ext + abs_b_ext;  // N bits + 1 bit sum
            
            // Check overflow: if carry out from MSB magnitude addition or abs_sum[N-1] is set
            // We check if abs_sum is greater than max magnitude possible (2^(N-1)-1)
            // Which means abs_sum[N] = carry out or bit beyond magnitude width set
            
            // If abs_sum[N] = 1 => overflow
            if (abs_sum[N] == 1'b1) begin
                overflow = 1'b1;
            end

            if (!overflow) begin
                // No overflow: assign result sign and magnitude lower bits
                sign_res = sign_a;
                c = {sign_res, abs_sum[N-1:1]};  // Take the N-1 LSB magnitude bits
            end else begin
                // Saturate based on sign
                if (sign_a == 1'b0)
                    c = max_pos;
                else
                    c = max_neg;
            end
        end else begin
            // Different signs: subtract smaller magnitude from larger magnitude
            if (abs_a_ge_b) begin
                abs_diff = abs_a_raw - abs_b_raw;
                sign_res = sign_a;
            end else begin
                abs_diff = abs_b_raw - abs_a_raw;
                sign_res = sign_b;
            end

            // If result zero, set sign to 0 (positive zero)
            if (abs_diff == 0)
                sign_res = 1'b0;

            // Compose output
            c = {sign_res, abs_diff};
        end
    end

endmodule