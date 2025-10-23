module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Constants for saturation
    localparam [N-1:0] MAX_POS = {1'b0, {(N-1){1'b1}}};
    localparam [N-1:0] MAX_NEG = {1'b1, {(N-1){1'b0}}};

    // Internal full-width sum including carry out
    wire [N:0] full_sum = {1'b0, a} + {1'b0, b};

    // Overflow occurs when:
    // 1. Both operands positive and result negative, OR
    // 2. Both operands negative and result positive
    wire overflow = (~a[N-1] & ~b[N-1] & full_sum[N-1]) |  // Case 1
                   (a[N-1] & b[N-1] & ~full_sum[N-1]);    // Case 2

    // Result selection
    assign c = overflow ? (a[N-1] ? MAX_NEG : MAX_POS) :  // Saturated
                      full_sum[N-1:0];                    // Normal result

endmodule