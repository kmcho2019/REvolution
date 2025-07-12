// 1-bit full adder module
module full_adder (
    input  wire a,      // input bit a
    input  wire b,      // input bit b
    input  wire cin,    // carry in
    output wire sum,    // sum bit
    output wire cout    // carry out
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 8-bit adder module using ripple carry full adders
module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry in
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry out
);
    wire [7:0] carry;  // internal carry wires

    // Instantiate full adders in a ripple carry chain
    // Bit 0
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );
    // Bits 1 to 6
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : gen_fa
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Final carry-out
    assign cout = carry[7];
endmodule