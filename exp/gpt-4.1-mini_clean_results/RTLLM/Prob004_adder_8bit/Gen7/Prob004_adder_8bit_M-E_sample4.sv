module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Full adder logic
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [3:0] carry; // carry[0] = cin, carry[3] = carry into MSB, carry[4] = cout internally
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_fa_4bit
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[4];
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    // Lower 4 bits: ripple carry 4-bit adder
    wire [3:0] sum_low;
    wire       c_low;

    adder_4bit lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum_low),
        .cout(c_low)
    );

    // Upper 4 bits: two 4-bit adders for carry_in = 0 and carry_in = 1
    wire [3:0] sum_high_c0, sum_high_c1;
    wire       cout_c0, cout_c1;

    adder_4bit upper_adder_c0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum_high_c0),
        .cout(cout_c0)
    );

    adder_4bit upper_adder_c1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum_high_c1),
        .cout(cout_c1)
    );

    // Select sum and cout of upper half based on lower half carry out
    wire [3:0] sum_high;
    wire       cout_high;

    assign sum_high = c_low ? sum_high_c1 : sum_high_c0;
    assign cout_high = c_low ? cout_c1 : cout_c0;

    // Combine lower and upper sums
    assign sum = {sum_high, sum_low};
    assign cout = cout_high;
endmodule