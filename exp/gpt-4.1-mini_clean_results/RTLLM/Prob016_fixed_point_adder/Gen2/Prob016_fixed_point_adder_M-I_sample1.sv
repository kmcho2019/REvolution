module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-2:0] abs_a;
    reg [N-2:0] abs_b;
    reg [N-1:0] sum_mag;
    reg [N-1:0] diff_mag;
    reg        sign_a;
    reg        sign_b;
    reg        sign_res;
    reg [N-1:0] res;

    always @* begin
        // Extract sign bits
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute absolute values of a and b (magnitude only)
        // If sign bit is 1 (negative), take two's complement magnitude excluding sign bit
        if (sign_a)
            abs_a = (~a[N-2:0] + 1'b1);
        else
            abs_a = a[N-2:0];

        if (sign_b)
            abs_b = (~b[N-2:0] + 1'b1);
        else
            abs_b = b[N-2:0];

        if (sign_a == sign_b) begin
            // Same signs: add magnitudes and keep sign
            sum_mag = {1'b0, abs_a} + {1'b0, abs_b};
            // Check if sum_mag overflows N-1 bits (i.e. carry out)
            // Overflow is naturally wrapped in two's complement; assign lower N-1 bits
            res[N-2:0] = sum_mag[N-2:0];
            res[N-1]   = sign_a;  // result sign same as inputs
        end else begin
            // Different signs: subtract smaller magnitude from larger magnitude
            if (abs_a >= abs_b) begin
                diff_mag = {1'b0, abs_a} - {1'b0, abs_b};
                res[N-2:0] = diff_mag[N-2:0];
                // sign of result same as sign_a (the larger magnitude operand)
                sign_res = (diff_mag == 0) ? 1'b0 : sign_a;
                res[N-1] = sign_res;
            end else begin
                diff_mag = {1'b0, abs_b} - {1'b0, abs_a};
                res[N-2:0] = diff_mag[N-2:0];
                // sign of result same as sign_b (the larger magnitude operand)
                sign_res = (diff_mag == 0) ? 1'b0 : sign_b;
                res[N-1] = sign_res;
            end
        end

        c = res;
    end

endmodule