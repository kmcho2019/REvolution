module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register for result
    reg [N-1:0] res;

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values of a and b (magnitude)
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Intermediate variables
    reg [N-1:0] magnitude_result;
    reg        result_sign;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: res = |a| - |b| with sign = a_sign
            if (a_abs >= b_abs) begin
                magnitude_result = a_abs - b_abs;
                result_sign = a_sign;
            end else begin
                magnitude_result = b_abs - a_abs;
                // Result sign same as inputs when same sign, so keep a_sign
                // But since subtracting smaller from larger, result sign is same as inputs
                // Actually, if both operands have same sign, subtract smaller magnitude from larger magnitude,
                // result sign is sign of larger magnitude operand (which is sign of inputs)
                // Since inputs have same sign, sign stays the same
                // But in case a_abs < b_abs, actually result sign flips? 
                // According to the prompt, "sign of the result will be the same as the inputs"
                // So sign = a_sign always
                result_sign = a_sign;
            end
        end else begin
            // Different sign subtraction == addition of absolute values, sign depends on relative size
            magnitude_result = a_abs + b_abs;
            // Result sign depends on which operand has the larger magnitude
            if (a_abs >= b_abs)
                result_sign = a_sign;
            else
                result_sign = b_sign;
        end

        // If result is zero, force sign bit to 0
        if (magnitude_result == 0) begin
            res = {1'b0, {(N-1){1'b0}}};
        end else begin
            // Assign sign bit and magnitude_result as two's complement value
            if (result_sign) begin
                // Negative result: two's complement of magnitude_result
                res = ~magnitude_result + 1'b1;
            end else begin
                // Positive result: magnitude_result as is
                res = magnitude_result;
            end
        end

        c = res;
    end

endmodule