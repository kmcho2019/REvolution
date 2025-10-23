// Bit-level full adder module with propagate and generate signals
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire p, g;
    assign p = a ^ b;           // propagate
    assign g = a & b;           // generate
    assign sum = p ^ cin;       // sum bit
    assign cout = g | (p & cin); // carry out
endmodule

// 4-bit ripple carry adder composed of bit_full_adders using generate
module adder_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [3:0] carry;

    // First bit adder: carry-in is cin
    bit_full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : bit_adders
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign cout = carry[3];
endmodule

// 8-bit adder using two 4-bit adders chained hierarchically
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire c4;

    // Lower nibble adder
    adder_4bit lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(c4)
    );

    // Upper nibble adder
    adder_4bit upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule