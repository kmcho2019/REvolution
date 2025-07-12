module fixed_point_adder #(
    parameter integer Q = 8,           // Number of fractional bits
    parameter integer N = 16           // Total bits including sign and fraction
)(
    input  wire signed [N-1:0] a,      // First fixed-point operand (signed two's complement)
    input  wire signed [N-1:0] b,      // Second fixed-point operand (signed two's complement)
    output reg  signed [N-1:0] c       // Fixed-point addition result (signed two's complement)
);

    // Internal signed registers for absolute values (N-1 bits magnitude)
    reg signed [N-2:0] abs_a;
    reg signed [N-2:0] abs_b;

    // Internal registers for sign bits
    reg sign_a;
    reg sign_b;
    reg sign_res;

    // Intermediate wider result to hold addition/subtraction result with carry/borrow
    reg signed [N-1:0] abs_sum;        // For addition of absolute values
    reg signed [N-1:0] abs_diff;       // For subtraction of absolute values

    // Internal result register
    reg signed [N-1:0] res;

    always @(*) begin
        // Extract signs: MSB is sign bit
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute absolute values (N-1 bits magnitude)
        // For negative numbers, negate; for positive, just take bits [N-2:0]
        abs_a = sign_a ? -a[N-2:0] : a[N-2:0];
        abs_b = sign_b ? -b[N-2:0] : b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            abs_sum = {1'b0, abs_a} + {1'b0, abs_b};  // N bits to hold carry
            // Sign of result same as operands
            sign_res = sign_a;

            // Compose result: sign bit + lower N-1 bits of abs_sum (wrap-around if overflow)
            res = {sign_res, abs_sum[N-2:0]};
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (abs_a > abs_b) begin
                abs_diff = {1'b0, abs_a} - {1'b0, abs_b};
                sign_res = sign_a; // sign of larger magnitude operand

                // If difference zero, sign positive zero
                if (abs_diff[N-2:0] == 0) begin
                    sign_res = 1'b0;
                end

                res = {sign_res, abs_diff[N-2:0]};
            end else if (abs_b > abs_a) begin
                abs_diff = {1'b0, abs_b} - {1'b0, abs_a};
                sign_res = sign_b; // sign of larger magnitude operand

                // If difference zero, sign positive zero
                if (abs_diff[N-2:0] == 0) begin
                    sign_res = 1'b0;
                end

                res = {sign_res, abs_diff[N-2:0]};
            end else begin
                // abs_a == abs_b, result zero with positive sign
                res = {1'b0, {(N-1){1'b0}}};
            end
        end

        // Assign output
        c = res;
    end

endmodule

/*
Improvement highlights:

- Inputs and outputs are declared as signed [N-1:0] to directly model two's complement fixed-point.
- Absolute values computed by conditional negation rather than bitwise inversion and addition.
- Uses signed addition/subtraction on magnitude parts with extended bit width to hold carry/borrow.
- Sign bits stored explicitly for clarity.
- Result constructed by combining sign bit with magnitude bits.
- Default parameter values provided for easier integration and testbench instantiation.
- Internal signals declared as signed for correct arithmetic operations.
- Overflow behavior wraps naturally due to fixed width.
- Clean and synthesizable combinational logic in always @(*) block.
*/