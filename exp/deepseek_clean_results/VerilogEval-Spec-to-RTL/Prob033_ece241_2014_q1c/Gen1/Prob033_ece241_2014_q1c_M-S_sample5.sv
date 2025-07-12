module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [8:0] sum; // 9-bit sum to capture carry out
    wire carry_in, carry_out;

    // Perform 8-bit addition and capture carry out
    assign sum = a + b;
    assign s = sum[7:0];
    assign carry_out = sum[8];

    // Calculate carry into MSB (bit 7)
    assign carry_in = (a[6:0] + b[6:0]) >> 7;

    // Overflow occurs when carry in ≠ carry out for MSB
    assign overflow = carry_in ^ carry_out;

endmodule