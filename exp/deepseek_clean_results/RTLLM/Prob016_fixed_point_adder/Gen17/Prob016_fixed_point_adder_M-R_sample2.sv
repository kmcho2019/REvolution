module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16,    // Total number of bits
    parameter SATURATE = 0  // 0: wrap-around, 1: saturate
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire [N-1:0] sum_raw;
    wire overflow;
    wire [N-1:0] saturated_pos = {1'b0, {(N-1){1'b1}}};  // Max positive
    wire [N-1:0] saturated_neg = {1'b1, {(N-1){1'b0}}};  // Max negative

    // Raw addition
    assign sum_raw = a + b;

    // Overflow occurs when signs match but result sign differs
    assign overflow = (~a[N-1] & ~b[N-1] & sum_raw[N-1]) |  // Positive overflow
                     (a[N-1] & b[N-1] & ~sum_raw[N-1]);    // Negative overflow

    // Output with optional saturation
    assign c = (SATURATE & overflow) ? 
               (a[N-1] ? saturated_neg : saturated_pos) :  // Saturate if enabled
               sum_raw;                                    // Otherwise pass through

endmodule