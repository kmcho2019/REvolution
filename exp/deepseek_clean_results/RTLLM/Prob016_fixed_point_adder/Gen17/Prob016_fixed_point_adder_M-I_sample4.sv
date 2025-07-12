module fixed_point_adder #(
    parameter Q = 8,        // Fractional bits (default 8)
    parameter N = 16        // Total bits (default 16)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output wire overflow
);

    // Internal signals
    wire [N-1:0] sum = a + b;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire sum_sign = sum[N-1];

    // Overflow occurs when:
    // 1. Adding two positives yields negative (overflow)
    // 2. Adding two negatives yields positive (underflow)
    assign overflow = (~a_sign & ~b_sign & sum_sign) | 
                     (a_sign & b_sign & ~sum_sign);

    always @(*) begin
        if (overflow) begin
            // Saturate to maximum positive or negative
            c = a_sign ? {1'b1, {(N-1){1'b0}}} :  // Most negative
                        {1'b0, {(N-1){1'b1}}};   // Most positive
        end else begin
            c = sum;  // Normal case
        end
    end

endmodule