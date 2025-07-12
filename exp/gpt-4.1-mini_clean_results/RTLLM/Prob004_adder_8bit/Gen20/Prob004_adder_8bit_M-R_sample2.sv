// Single-bit full adder with minimal logic
module bit_full_adder (
    input  wire a,       // single-bit input A
    input  wire b,       // single-bit input B
    input  wire cin,     // carry-in input
    output wire sum,     // sum output
    output wire cout     // carry-out output
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 8-bit ripple carry adder using generate block for instantiations
module adder_8bit (
    input  wire [7:0] a,    // 8-bit input operand A
    input  wire [7:0] b,    // 8-bit input operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire [8:0] carry;       // Internal carry signals, carry[0] = cin

    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[8];
endmodule