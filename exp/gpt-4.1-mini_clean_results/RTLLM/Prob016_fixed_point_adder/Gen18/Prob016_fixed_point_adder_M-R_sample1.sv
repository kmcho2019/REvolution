module fixed_point_adder #(
    parameter integer Q = 8,           // Number of fractional bits
    parameter integer N = 16           // Total width including sign and fractional bits
)(
    input  wire [N-1:0] a,             // First fixed-point operand (two's complement)
    input  wire [N-1:0] b,             // Second fixed-point operand (two's complement)
    output reg  [N-1:0] c              // Fixed-point sum result
);

    reg [N-2:0] abs_a;     // Absolute value bits of a (excluding sign)
    reg [N-2:0] abs_b;     // Absolute value bits of b (excluding sign)
    reg [N-1:0] sum_abs;   // Sum or difference of absolute values
    reg sign_a;
    reg sign_b;
    reg sign_res;
    reg [N-2:0] mag_res;   // Magnitude result without sign bit

    // Compute absolute values function (two's complement abs)
    function [N-2:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0)
                abs_val = val[N-2:0];
            else
                abs_val = (~val[N-2:0] + 1'b1);
        end
    endfunction

    always @* begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        abs_a = abs_val(a);
        abs_b = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            sum_abs = abs_a + abs_b;
            sign_res = sign_a;
            // Handle overflow: if sum_abs exceeds max magnitude, truncate
            if (sum_abs[N-2])  // Check if sum overflowed magnitude bits
                mag_res = { (N-2){1'b1} };  // Saturate magnitude (all 1s)
            else
                mag_res = sum_abs[N-2:0];
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (abs_a > abs_b) begin
                mag_res = abs_a - abs_b;
                sign_res = sign_a;  // Sign of larger magnitude
            end else if (abs_b > abs_a) begin
                mag_res = abs_b - abs_a;
                sign_res = sign_b;
            end else begin
                // Magnitudes equal -> result zero
                mag_res = 0;
                sign_res = 0;
            end
        end

        // Compose final result
        c = {sign_res, mag_res};
    end

endmodule