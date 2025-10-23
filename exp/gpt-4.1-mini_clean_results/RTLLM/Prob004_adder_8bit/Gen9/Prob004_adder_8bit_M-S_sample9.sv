module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
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

    // Define carry-in for bit 0 as cin by extending carry to -1 index via a wire
    wire [8:0] carry_chain = {carry[7:0], cin};

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_fa
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry_chain[i]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign cout = carry[7];
endmodule