module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Perform 9-bit addition to capture carry out
    wire [8:0] full_sum = {1'b0, a} + {1'b0, b};
    assign s = full_sum[7:0];

    // Calculate carry into MSB (bit 7) and carry out of MSB (bit 8)
    wire carry_into_msb = ((a[6] & b[6]) | ((a[6] ^ b[6]) & full_sum[6]));
    wire carry_out_msb = full_sum[8];

    // Overflow is XOR of carry into MSB and carry out of MSB
    assign overflow = carry_into_msb ^ carry_out_msb;

endmodule