module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Direct two's complement addition
    wire [N:0] extended_sum = {a[N-1], a} + {b[N-1], b};
    
    // Overflow occurs when sign bits don't match result
    assign overflow = (a[N-1] == b[N-1]) && (extended_sum[N] != extended_sum[N-1]);
    
    // Truncate result to N bits
    assign c = extended_sum[N-1:0];

endmodule