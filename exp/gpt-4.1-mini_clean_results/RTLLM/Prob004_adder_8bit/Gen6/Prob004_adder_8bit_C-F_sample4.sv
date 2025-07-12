// Single bit full adder module
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Full adder implementation
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 4-bit ripple carry adder using bit_full_adders with generate loop
module adder_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [4:0] carry;  // carry[0] = cin, carry[4] = cout

    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_fa
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

// 8-bit adder built by chaining two 4-bit adders
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire carry_mid;

    // Lower 4 bits adder instance
    adder_4bit lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(carry_mid)
    );

    // Upper 4 bits adder instance
    adder_4bit upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_mid),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule