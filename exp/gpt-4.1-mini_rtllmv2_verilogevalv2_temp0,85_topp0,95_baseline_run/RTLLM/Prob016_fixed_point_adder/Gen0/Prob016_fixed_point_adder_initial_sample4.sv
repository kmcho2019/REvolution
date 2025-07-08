module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    reg [N-1:0] res;

    // Internal signals for sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values of a and b
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare absolute values
    wire a_abs_greater = (a_abs > b_abs);
    wire abs_equal = (a_abs == b_abs);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values, keep sign
            res = a_abs + b_abs;
            // If overflow on addition of unsigned values, it wraps around - no saturation
            // Set sign bit accordingly
            if (res[N-1]) begin
                // Overflow on magnitude addition; wrap-around - this is expected behavior in 2's complement
                // Just keep the sign bit same as inputs
                res[N-1] = a_sign;
            end else begin
                res[N-1] = a_sign;
            end
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_abs_greater) begin
                // a has larger abs: result = a_abs - b_abs, sign = a_sign (which is 1 = negative or 0 = positive)
                res = a_abs - b_abs;
                // Set sign bit to a_sign (0 means positive, 1 means negative)
                res[N-1] = a_sign;
                // If result is zero, sign bit should be 0 (positive zero)
                if (res == 0)
                    res[N-1] = 1'b0;
            end else if (abs_equal) begin
                // Equal abs means result is zero
                res = 0;
            end else begin
                // b_abs > a_abs: result = b_abs - a_abs, sign = b_sign
                res = b_abs - a_abs;
                res[N-1] = b_sign;
                if (res == 0)
                    res[N-1] = 1'b0;
            end
        end
    end

    assign c = res;

endmodule