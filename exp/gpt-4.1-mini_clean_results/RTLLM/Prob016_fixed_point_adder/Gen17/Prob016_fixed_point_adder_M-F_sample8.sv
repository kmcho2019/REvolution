module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign
)(
    input  wire [N-1:0] a,        // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,        // Fixed-point input operand B (two's complement)
    output wire [N-1:0] c         // Fixed-point addition result (two's complement)
);

    // Internal registers for absolute values and result
    reg [N-1:0] abs_a;
    reg [N-1:0] abs_b;
    reg [N-1:0] sum_abs;
    reg [N-1:0] diff_abs;
    reg [N-1:0] res;

    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Function to compute absolute value of two's complement input
    function [N-1:0] abs_val;
        input [N-1:0] val;
        input       sign;
        begin
            if (sign)
                abs_val = (~val) + 1'b1;  // two's complement negation
            else
                abs_val = val;
        end
    endfunction

    // Combinational logic for fixed-point addition
    always @* begin
        abs_a = abs_val(a, sign_a);
        abs_b = abs_val(b, sign_b);

        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            sum_abs = abs_a + abs_b;

            // result sign same as inputs' sign
            // If overflow in sum_abs (bit N) occurs, wrap around (truncate)
            res = {sign_a, sum_abs[N-2:0]};
        end else begin
            // Opposite signs: subtract smaller absolute from larger absolute
            if (abs_a == abs_b) begin
                // Result zero, sign zero
                res = {1'b0, {(N-1){1'b0}}};
            end else if (abs_a > abs_b) begin
                diff_abs = abs_a - abs_b;
                // Sign is sign_a (since abs_a > abs_b)
                res = {sign_a, diff_abs[N-2:0]};
            end else begin
                diff_abs = abs_b - abs_a;
                // Sign is sign_b (since abs_b > abs_a)
                res = {sign_b, diff_abs[N-2:0]};
            end
        end
    end

    assign c = res;

endmodule