module RippleCarryAdder4 (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire c1, c2, c3;

    // bit 0
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c1 = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    // bit 1
    assign sum[1] = a[1] ^ b[1] ^ c1;
    assign c2 = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);

    // bit 2
    assign sum[2] = a[2] ^ b[2] ^ c2;
    assign c3 = (a[2] & b[2]) | (a[2] & c2) | (b[2] & c2);

    // bit 3
    assign sum[3] = a[3] ^ b[3] ^ c3;
    assign cout = (a[3] & b[3]) | (a[3] & c3) | (b[3] & c3);
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [3:0] lower_sum;
    wire       lower_cout;

    // Upper sums and couts for carry_in = 0 and 1
    wire [3:0] upper_sum0, upper_sum1;
    wire       upper_cout0, upper_cout1;

    // Lower 4-bit adder with carry in = 0
    RippleCarryAdder4 lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(lower_sum),
        .cout(lower_cout)
    );

    // Upper 4-bit adder assuming carry_in = 0
    RippleCarryAdder4 upper_adder0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(upper_sum0),
        .cout(upper_cout0)
    );

    // Upper 4-bit adder assuming carry_in = 1
    RippleCarryAdder4 upper_adder1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(upper_sum1),
        .cout(upper_cout1)
    );

    // Select upper sum and carry_out based on lower carry out
    wire [3:0] upper_sum = lower_cout ? upper_sum1 : upper_sum0;
    wire       upper_cout = lower_cout ? upper_cout1 : upper_cout0;

    assign s = {upper_sum, lower_sum};

    // Overflow detection: overflow = carry_into_MSB ^ carry_out_MSB
    // carry_into_MSB is carry into bit 7, which is carry out of bit 6
    // carry_into_MSB = if lower_cout=0, carry into MSB = c3 of upper_adder0,
    // else c3 of upper_adder1.
    // We can reconstruct c3 from sum and inputs or replicate c3 signals.

    // To avoid complexity, use intermediate signals from upper adders.

    // Let's extract carry into MSB bit (carry into bit 7) from upper adders:
    // c3 in upper adder is carry out of bit 2 (index 2)
    // Compute carry into MSB as follows:

    // For upper_adder0 carry_in=0
    wire c1_0, c2_0, c3_0;
    assign c1_0 = (a[4] & b[4]) | (a[4] & 1'b0) | (b[4] & 1'b0);
    assign c2_0 = (a[5] & b[5]) | (a[5] & c1_0) | (b[5] & c1_0);
    assign c3_0 = (a[6] & b[6]) | (a[6] & c2_0) | (b[6] & c2_0);

    // For upper_adder1 carry_in=1
    wire c1_1, c2_1, c3_1;
    assign c1_1 = (a[4] & b[4]) | (a[4] & 1'b1) | (b[4] & 1'b1);
    assign c2_1 = (a[5] & b[5]) | (a[5] & c1_1) | (b[5] & c1_1);
    assign c3_1 = (a[6] & b[6]) | (a[6] & c2_1) | (b[6] & c2_1);

    wire carry_into_msb = lower_cout ? c3_1 : c3_0;

    assign overflow = carry_into_msb ^ upper_cout;
endmodule