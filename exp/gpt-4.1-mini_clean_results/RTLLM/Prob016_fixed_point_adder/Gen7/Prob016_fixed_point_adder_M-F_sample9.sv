module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including integer and fractional parts
)(
    input  wire [N-1:0] a,        // Fixed-point input operand A
    input  wire [N-1:0] b,        // Fixed-point input operand B
    output reg  [N-1:0] c         // Fixed-point addition result
);

    // Internal register to hold the result
    reg [N-1:0] res;

    // Extract sign bits (MSB)
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values by two's complement if negative, else unchanged
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            // Result sign same as operands
            reg [N:0] sum_ext; // One bit wider to detect overflow
            sum_ext = {1'b0, a_abs} + {1'b0, b_abs};
            // Truncate to N bits, discard carry out (wrap-around)
            res = sum_ext[N-1:0];
            // Restore sign by applying two's complement if negative
            if (a_sign)
                res = ~res + 1'b1; // negate result if inputs were negative
        end else begin
            // Different signs: subtract smaller absolute value from bigger
            if (a_abs >= b_abs) begin
                // result = a_abs - b_abs, sign = a_sign (0 means positive)
                reg [N-1:0] diff;
                diff = a_abs - b_abs;
                // If result is zero, sign is 0 (positive)
                if (diff == 0)
                    res = 0;
                else
                    res = a_sign ? (~diff + 1'b1) : diff; // negate if a_sign=1
            end else begin
                // result = b_abs - a_abs, sign = b_sign
                reg [N-1:0] diff;
                diff = b_abs - a_abs;
                if (diff == 0)
                    res = 0;
                else
                    res = b_sign ? (~diff + 1'b1) : diff; // negate if b_sign=1
            end
        end
    end

    // Assign registered result to output
    always @(*) begin
        c = res;
    end

endmodule