module fixed_point_adder #(
    parameter Q = 8,       // Number of fractional bits
    parameter N = 16       // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to compute absolute value (two's complement)
    function [N-1:0] abs_val;
        input [N-1:0] in;
        begin
            if (in[N-1] == 1'b1)
                abs_val = (~in + 1'b1);
            else
                abs_val = in;
        end
    endfunction

    // Absolute values
    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    // Magnitude comparison
    wire abs_a_greater = (abs_a > abs_b);
    wire abs_equal     = (abs_a == abs_b);

    // Result register (combinational)
    reg [N-1:0] res;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add directly
            res = a + b;
        end else begin
            // Different signs: perform subtraction of smaller abs from larger abs
            if (abs_equal) begin
                // Magnitudes equal => result is zero
                res = {N{1'b0}};
            end else if (abs_a_greater) begin
                // Result sign = sign of 'a'
                res = a - b;
            end else begin
                // Result sign = sign of 'b'
                res = b - a;
            end
        end
    end

    assign c = res;

endmodule