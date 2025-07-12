module fixed_point_adder #(
    // Number of fractional bits (precision)
    parameter integer Q = 8,
    // Total number of bits (integer + fractional + sign)
    parameter integer N = 16
) (
    input  wire [N-1:0] a,  // First operand in fixed-point two's complement
    input  wire [N-1:0] b,  // Second operand in fixed-point two's complement
    output reg  [N-1:0] c   // Result of fixed-point addition
);

    // Internal registers for sign bits and magnitudes
    reg sign_a;
    reg sign_b;
    reg [N-2:0] abs_a;
    reg [N-2:0] abs_b;

    // Intermediate sums and differences (width N to hold carry/borrow)
    reg [N-1:0] sum_mag;
    reg [N-1:0] diff_mag;

    reg sign_res;     // Result sign
    reg [N-1:0] res;  // Internal result register

    always @* begin
        // Extract sign bits (MSB)
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute magnitudes (absolute values) of a and b
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
            // Same sign: add magnitudes
            sum_mag = {1'b0, abs_a} + {1'b0, abs_b};
            // Assign lower N-1 bits to result magnitude
            res[N-2:0] = sum_mag[N-2:0];
            // Sign bit is same as inputs'
            res[N-1] = sign_a;
        end else begin
            // Different signs: subtract smaller magnitude from larger magnitude
            if (abs_a >= abs_b) begin
                diff_mag = {1'b0, abs_a} - {1'b0, abs_b};
                res[N-2:0] = diff_mag[N-2:0];
                // If difference zero, sign is zero (positive)
                sign_res = (diff_mag == 0) ? 1'b0 : sign_a;
                res[N-1] = sign_res;
            end else begin
                diff_mag = {1'b0, abs_b} - {1'b0, abs_a};
                res[N-2:0] = diff_mag[N-2:0];
                // If difference zero, sign is zero (positive)
                sign_res = (diff_mag == 0) ? 1'b0 : sign_b;
                res[N-1] = sign_res;
            end
        end

        c = res;
    end

endmodule