module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Gate-level full adder logic
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry;

    genvar i;
    generate
        // First bit full adder: carry-in is external cin
        bit_full_adder fa0 (
            .a(a[0]),
            .b(b[0]),
            .cin(cin),
            .sum(sum[0]),
            .cout(carry[0])
        );

        // Bits 1 through 7 full adders chained by carry
        for (i = 1; i < 8; i = i + 1) begin : gen_fa
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign cout = carry[7];
endmodule