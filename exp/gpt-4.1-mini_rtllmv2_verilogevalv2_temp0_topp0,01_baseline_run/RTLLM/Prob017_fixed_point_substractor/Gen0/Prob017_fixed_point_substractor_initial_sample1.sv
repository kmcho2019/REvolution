module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values of a and b
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Intermediate variables
    reg [N-1:0] temp_res;
    reg        res_sign;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: subtract b from a
            temp_res = a - b;
            res_sign = temp_res[N-1];
        end else begin
            // Different signs: add absolute values
            if (a_abs >= b_abs) begin
                temp_res = a_abs + b_abs;
                res_sign = a_sign; // sign of the operand with larger magnitude
            end else begin
                temp_res = b_abs + a_abs;
                res_sign = b_sign;
            end

            // Adjust temp_res to signed value with correct sign
            if (res_sign) begin
                // Negative result: take two's complement
                temp_res = ~temp_res + 1'b1;
            end
        end

        // Handle zero result: clear sign bit
        if (temp_res == 0) begin
            res = {1'b0, {(N-1){1'b0}}};
        end else begin
            res = temp_res;
        end

        c = res;
    end

endmodule