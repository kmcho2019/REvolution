module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,        // First fixed-point operand
    input  wire [N-1:0] b,        // Second fixed-point operand
    output wire [N-1:0] c         // Result of fixed-point addition
);

    // Internal register for result
    reg [N-1:0] res;

    // Extract sign bits (MSB)
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to compute absolute value for two's complement fixed-point number
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            if(val[N-1]) // if negative
                abs_val = (~val + 1'b1);
            else
                abs_val = val;
        end
    endfunction

    // Compute absolute values of inputs
    wire [N-1:0] a_abs = abs_val(a);
    wire [N-1:0] b_abs = abs_val(b);

    // Compare absolute values
    wire a_abs_ge_b_abs = (a_abs >= b_abs);

    // Intermediate sum or difference with one extra bit for overflow/borrow
    reg [N:0] abs_add_sub;

    // Combinational logic for fixed-point addition
    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            abs_add_sub = {1'b0, a_abs} + {1'b0, b_abs};
            // Result sign same as inputs' sign bit
            res = abs_add_sub[N-1:0];
            res[N-1] = a_sign; // preserve sign
        end else begin
            // Different signs: perform absolute subtraction
            if (a_abs_ge_b_abs) begin
                abs_add_sub = {1'b0, a_abs} - {1'b0, b_abs};
                if (abs_add_sub[N-1:0] == 0) begin
                    // Result zero: positive zero
                    res = {N{1'b0}};
                end else begin
                    // Result positive, sign bit = 0
                    res = abs_add_sub[N-1:0];
                    res[N-1] = 1'b0;
                end
            end else begin
                abs_add_sub = {1'b0, b_abs} - {1'b0, a_abs};
                if (abs_add_sub[N-1:0] == 0) begin
                    // Result zero: positive zero
                    res = {N{1'b0}};
                end else begin
                    // Result sign same as b's sign bit (which differs from a)
                    res = abs_add_sub[N-1:0];
                    res[N-1] = b_sign;
                end
            end
        end
    end

    // Assign internal register to output
    assign c = res;

endmodule