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
    wire [N-1:0] sum;
    wire a_sign, b_sign, sum_sign;
    wire overflow_pos, overflow_neg;

    // Sign bits
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    
    // Actual addition
    assign sum = a + b;
    assign sum_sign = sum[N-1];

    // Overflow detection
    assign overflow_pos = (~a_sign & ~b_sign & sum_sign);  // Positive overflow
    assign overflow_neg = (a_sign & b_sign & ~sum_sign);   // Negative overflow
    assign overflow = overflow_pos | overflow_neg;

    // Saturation logic
    always @(*) begin
        case ({overflow_pos, overflow_neg})
            2'b10: c = {1'b0, {(N-1){1'b1}}};    // Saturate to max positive
            2'b01: c = {1'b1, {(N-1){1'b0}}};    // Saturate to max negative
            default: c = sum;                    // Normal case
        endcase
    end

endmodule