module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

wire [7:0] sum;
wire carry_in_msb;
wire carry_out_msb;

assign {carry_out_msb, s} = a + b;
assign carry_in_msb = ((a[6] & b[6]) | (a[6] & ~s[6]) | (b[6] & ~s[6])); // carry into MSB
// However, for overflow, the standard method with carries is: overflow = carry_in_msb ^ carry_out_msb
// But carry_in_msb is the carry into MSB bit 7, which is carry_out of bit 6 addition.
// Instead of approximating carry_in_msb manually, we compute it from addition of lower 7 bits:
wire carry_into_msb;
wire [6:0] lower_sum;

assign {carry_into_msb, lower_sum} = a[6:0] + b[6:0];
assign overflow = carry_into_msb ^ carry_out_msb;

endmodule