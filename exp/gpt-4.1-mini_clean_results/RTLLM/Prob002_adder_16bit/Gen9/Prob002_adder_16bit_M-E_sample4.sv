// 4-bit ripple carry adder: sums a,b with carry-in Cin, outputs sum and carry-out
module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] sum,
    output       Co
);
    wire [3:0] carry;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
    assign sum[0] = a[0] ^ b[0] ^ Cin;

    genvar i;
    generate
        for (i = 1; i < 4; i=i+1) begin : fa_loop
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    assign Co = carry[3];
endmodule


// 8-bit carry-select adder: uses two 4-bit ripple adders with carry-in 0 and 1, then selects the right sums and carry-out
module adder_8bit_cs (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Co
);
    wire [3:0] sum0, sum1;  // sum assuming carry_in=0 and carry_in=1 for upper 4 bits
    wire       c0, c1;      // carry out from upper 4 bits assuming carry_in=0 and carry_in=1
    wire       carry_lower; // carry out from lower 4 bits

    // Lower 4 bits ripple carry adder, real carry in
    adder_4bit low_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .sum(sum[3:0]),
        .Co(carry_lower)
    );

    // Upper 4 bits ripple carry adder assuming carry_in = 0
    adder_4bit upper_adder0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b0),
        .sum(sum0),
        .Co(c0)
    );

    // Upper 4 bits ripple carry adder assuming carry_in = 1
    adder_4bit upper_adder1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b1),
        .sum(sum1),
        .Co(c1)
    );

    // Select sum and carry based on actual carry from lower bits
    assign sum[7:4] = carry_lower ? sum1 : sum0;
    assign Co = carry_lower ? c1 : c0;
endmodule


// 16-bit adder built by cascading two 8-bit carry-select adders with ripple carry between them
module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] sum,
    output        Co
);
    wire c_mid;

    adder_8bit_cs low_part (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(sum[7:0]),
        .Co(c_mid)
    );

    adder_8bit_cs high_part (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_mid),
        .sum(sum[15:8]),
        .Co(Co)
    );
endmodule