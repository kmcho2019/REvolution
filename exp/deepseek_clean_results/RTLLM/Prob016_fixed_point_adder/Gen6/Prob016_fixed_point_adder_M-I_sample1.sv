module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire [N:0] sum_ext;  // Extended sum for overflow detection
    wire overflow, underflow;
    wire [N-1:0] sum_raw;

    // Main arithmetic operation
    assign sum_ext = {a[N-1], a} + {b[N-1], b};
    assign sum_raw = sum_ext[N-1:0];

    // Overflow/underflow detection
    assign overflow = ~a[N-1] & ~b[N-1] & sum_raw[N-1];
    assign underflow = a[N-1] & b[N-1] & ~sum_raw[N-1];

    // Result selection with saturation
    assign c = overflow ? {1'b0, {(N-1){1'b1}}} :  // Saturate to max positive
              underflow ? {1'b1, {(N-1){1'b0}}} :  // Saturate to max negative
              sum_raw;

endmodule