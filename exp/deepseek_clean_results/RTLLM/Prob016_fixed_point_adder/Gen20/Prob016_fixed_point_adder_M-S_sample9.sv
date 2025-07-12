module fixed_point_adder #(
    parameter Q = 8,        // Fractional bits (default 8)
    parameter N = 16        // Total bits (default 16)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-1:0] sum = a + b;
    wire sum_sign = sum[N-1];
    
    // Overflow occurs when adding same signs produces different sign
    wire overflow = (a_sign == b_sign) && (sum_sign != a_sign);

    always @(*) begin
        if (overflow) begin
            // Saturate to maximum positive or negative
            c = a_sign ? {1'b1, {(N-1){1'b0}}}  // Negative saturation
                      : {1'b0, {(N-1){1'b1}}};  // Positive saturation
        end else begin
            c = sum;  // Normal case
        end
    end

endmodule