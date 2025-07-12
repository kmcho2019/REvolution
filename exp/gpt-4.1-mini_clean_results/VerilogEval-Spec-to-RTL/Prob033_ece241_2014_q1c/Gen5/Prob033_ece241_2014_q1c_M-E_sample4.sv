module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] full_sum;

    // Perform addition with one extra bit for carry out
    assign full_sum = {1'b0, a} + {1'b0, b};
    assign s = full_sum[7:0];

    // Calculate carry into MSB (bit 7)
    wire carry_in_msb;
    assign carry_in_msb = ((a[6] & b[6]) | ((a[6] ^ b[6]) & full_sum[6]));

    // Carry out is the 9th bit of full_sum
    wire carry_out_msb = full_sum[8];

    // Overflow occurs if carry into MSB and carry out of MSB differ
    assign overflow = carry_in_msb ^ carry_out_msb;

endmodule