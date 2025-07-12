// Single bit full adder module
module full_adder_1bit (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 8-bit ripple carry adder using 1-bit full adders
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry;

    // First bit carry-in is cin
    // carry[7] is cout
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            full_adder_1bit fa (
                .a(a[i]),
                .b(b[i]),
                .cin(i == 0 ? cin : carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign cout = carry[7];
endmodule