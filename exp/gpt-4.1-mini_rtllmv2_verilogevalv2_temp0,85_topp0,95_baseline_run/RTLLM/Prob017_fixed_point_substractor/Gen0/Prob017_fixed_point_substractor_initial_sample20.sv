module fixed_point_subtractor #
(
    parameter integer Q = 8,       // Number of fractional bits
    parameter integer N = 16       // Total bits (integer + fractional + sign)
)
(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold the subtraction result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values of inputs
    wire [N-2:0] a_abs = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_abs = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Compare magnitudes for different sign cases
    wire a_greater_eq_b = (a_abs >= b_abs);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: subtract absolute values
            if (a_abs >= b_abs) begin
                // Result sign same as inputs
                res[N-1] = a_sign;
                res[N-2:0] = a_abs - b_abs;
            end else begin
                // Result sign same as inputs but with swapped operands
                res[N-1] = a_sign ? 1'b0 : 1'b1; // flip sign because result negative of inputs
                res[N-2:0] = b_abs - a_abs;
            end
        end else begin
            // Different signs: add absolute values
            // Result sign depends on magnitude comparison
            if (a_greater_eq_b) begin
                // Result sign is a's sign
                res[N-1] = a_sign;
                res[N-2:0] = a_abs + b_abs;
            end else begin
                // Result sign is b's sign
                res[N-1] = b_sign;
                res[N-2:0] = a_abs + b_abs;
            end
        end

        // Handle zero result: if magnitude zero, force sign 0
        if (res[N-2:0] == 0) begin
            res[N-1] = 1'b0;
        end

        c = res;
    end

endmodule