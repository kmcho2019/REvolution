module fixed_point_adder #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal register for result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to get absolute value of N-bit signed number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1) // negative
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Absolute values of a and b
    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    // Compare absolute values to determine subtraction order if signs differ
    wire abs_a_gte_b = (abs_a >= abs_b);

    // Internal signals for addition and subtraction
    wire [N-1:0] sum_abs = abs_a + abs_b;
    wire [N-1:0] diff_abs = abs_a_gte_b ? (abs_a - abs_b) : (abs_b - abs_a);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            res = sum_abs;
            // Set sign bit to common sign
            res[N-1] = a_sign;
        end else begin
            // Different signs: subtract smaller from larger abs value
            res = diff_abs;
            // Sign is sign of operand with larger absolute value
            if (diff_abs == 0) begin
                // Result zero: sign bit 0
                res[N-1] = 1'b0;
            end else begin
                res[N-1] = abs_a_gte_b ? a_sign : b_sign;
            end
        end
    end

    assign c = res;

endmodule