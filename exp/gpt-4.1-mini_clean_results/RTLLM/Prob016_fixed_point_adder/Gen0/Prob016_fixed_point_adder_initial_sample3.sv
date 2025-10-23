module fixed_point_adder #(
    parameter Q = 8,       // Number of fractional bits
    parameter N = 16       // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to get absolute value of two's complement fixed-point number
    function [N-1:0] abs_val;
        input [N-1:0] in;
        begin
            if (in[N-1] == 1'b1)
                abs_val = (~in + 1'b1);
            else
                abs_val = in;
        end
    endfunction

    // Internal wires for absolute values
    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    // Compare absolute values
    wire abs_a_greater = (abs_a > abs_b);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values, sign bit remains the same
            // Actually, for two's complement numbers of same sign, just add directly
            res = a + b;
        end else begin
            // Different sign: subtract smaller abs from larger abs
            if (abs_a_greater) begin
                // result sign = sign of a
                res = a_sign ? (a - b) : (a - b);
            end else if (abs_b > abs_a) begin
                // result sign = sign of b
                res = b_sign ? (b - a) : (b - a);
            end else begin
                // abs_a == abs_b, result is zero
                res = {N{1'b0}};
            end
        end
    end

    always @(*) begin
        c = res;
    end

endmodule