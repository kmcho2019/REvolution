module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    reg signed [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signed [N-1:0] a_abs = a_sign ? -a : a;
    wire signed [N-1:0] b_abs = b_sign ? -b : b;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign subtraction
            res = a - b;
            // Result sign same as inputs (since signs are same)
            if (res == 0) begin
                c = 0;  // Explicit zero handling
            end else begin
                c = res;
            end
        end else begin
            // Different signs - effectively addition of absolute values
            if (a_sign) begin
                // a is negative, b is positive
                res = b_abs - a_abs;
                c = (res[N-1] || (res == 0)) ? res : -res;
            end else begin
                // a is positive, b is negative
                res = a_abs - b_abs;
                c = (res[N-1] || (res == 0)) ? -res : res;
            end
            
            // Explicit zero handling
            if (res == 0) begin
                c = 0;
            end
        end
    end

endmodule