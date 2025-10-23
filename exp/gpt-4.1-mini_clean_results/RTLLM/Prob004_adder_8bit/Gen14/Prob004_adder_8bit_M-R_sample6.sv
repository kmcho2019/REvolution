// 1-bit full adder module
module full_adder (
    input  wire a,     // input bit A
    input  wire b,     // input bit B
    input  wire cin,   // carry-in
    output wire sum,   // sum output
    output wire cout   // carry-out
);
    // Sum is XOR of inputs and carry in
    assign sum = a ^ b ^ cin;
    // Carry-out is generated if at least two inputs are high
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 8-bit ripple carry adder using bit-level full adders
module adder_8bit (
    input  wire [7:0] a,     // 8-bit operand A
    input  wire [7:0] b,     // 8-bit operand B
    input  wire       cin,   // carry-in
    output wire [7:0] sum,   // 8-bit sum output
    output wire       cout   // carry-out
);
    wire [7:0] carry;  // internal carries between full adders

    // Instantiate 8 full adders connected in ripple carry fashion
    // Bit 0 full adder
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Bits 1 to 6 full adders
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : fa_chain
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