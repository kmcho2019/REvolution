module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits (precision)
    parameter integer N = 16    // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,      // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,      // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c       // Fixed-point addition result (two's complement)
);

    // Internal registers for absolute values and intermediate results
    reg [N-1:0] abs_a;
    reg [N-1:0] abs_b;
    reg [N:0] sum_abs;          // One extra bit for carry
    reg [N:0] diff_abs;         // One extra bit for borrow
    reg sign_a, sign_b;
    reg sign_res;
    reg [N-1:0] res;

    // Constants for saturation
    localparam [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};  // Max positive: 0 followed by ones
    localparam [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};  // Min negative: 1 followed by zeros

    // Function to compute absolute value of two's complement input
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0)
                abs_val = val;
            else
                abs_val = (~val) + 1'b1; // Two's complement negation
        end
    endfunction

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        abs_a = abs_val(a);
        abs_b = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            sum_abs = abs_a + abs_b;

            // Check overflow: if sum_abs[N] == 1, saturation occurs
            if (sum_abs[N] == 1'b1) begin
                // Overflow saturation
                res = (sign_a == 1'b0) ? MAX_VAL : MIN_VAL;
                sign_res = sign_a;
            end else begin
                // No overflow
                res = sum_abs[N-1:0];
                sign_res = sign_a;
            end
        end else begin
            // Different sign: subtract smaller absolute from larger
            if (abs_a >= abs_b) begin
                diff_abs = abs_a - abs_b;
                res = diff_abs[N-1:0];
                // Result sign is sign of larger abs value operand (a)
                if (diff_abs == 0)
                    sign_res = 1'b0; // Positive zero
                else
                    sign_res = sign_a;
            end else begin
                diff_abs = abs_b - abs_a;
                res = diff_abs[N-1:0];
                // Result sign is sign of larger abs value operand (b)
                if (diff_abs == 0)
                    sign_res = 1'b0; // Positive zero
                else
                    sign_res = sign_b;
            end
        end

        // Compose final result with sign bit
        if (res == 0) begin
            // Zero result: force sign bit to zero (positive zero)
            c = {1'b0, { (N-1){1'b0} }};
        end else begin
            c = {sign_res, res[N-2:0]};
        end
    end

endmodule