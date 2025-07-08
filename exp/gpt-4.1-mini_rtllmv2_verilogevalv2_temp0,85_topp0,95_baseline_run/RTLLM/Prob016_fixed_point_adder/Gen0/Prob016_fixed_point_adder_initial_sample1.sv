module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal registers
    reg [N-2:0] a_abs;
    reg [N-2:0] b_abs;
    reg [N-1:0] res;
    reg        res_sign;

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    always @(*) begin
        // Extract absolute values (excluding MSB)
        a_abs = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
        b_abs = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            reg [N-1:0] sum_abs;
            sum_abs = {1'b0, a_abs} + {1'b0, b_abs};
            // If sum_abs exceeds N-1 bits, it wraps naturally
            // Assign sign bit same as inputs
            res_sign = a_sign;
            // Check if sum_abs[ N-1 ] bit is 1 (overflow in magnitude)
            // Saturation or wrap-around not explicitly handled, natural wrap
            if (res_sign) begin
                // Negative number: take two's complement
                reg [N-1:0] neg_val;
                neg_val = ~sum_abs + 1'b1;
                res = neg_val;
            end else begin
                res = sum_abs;
            end
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_abs >= b_abs) begin
                reg [N-1:0] diff_abs;
                diff_abs = {1'b0, a_abs} - {1'b0, b_abs};
                if (diff_abs == 0) begin
                    // Result zero, sign = 0
                    res = 0;
                    res_sign = 0;
                end else begin
                    // Sign same as a
                    res_sign = a_sign;
                    if (res_sign) begin
                        // Negative result: two's complement
                        res = ~diff_abs + 1'b1;
                    end else begin
                        res = diff_abs;
                    end
                end
            end else begin
                reg [N-1:0] diff_abs;
                diff_abs = {1'b0, b_abs} - {1'b0, a_abs};
                if (diff_abs == 0) begin
                    // Result zero, sign = 0
                    res = 0;
                    res_sign = 0;
                end else begin
                    // Sign same as b
                    res_sign = b_sign;
                    if (res_sign) begin
                        // Negative result: two's complement
                        res = ~diff_abs + 1'b1;
                    end else begin
                        res = diff_abs;
                    end
                end
            end
        end

        // Assign result with sign bit
        c = {res_sign, res[N-2:0]};
    end

endmodule