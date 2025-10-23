// Single-bit full adder using combinational assign statements
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

// 2-bit carry lookahead unit to generate internal carries
module carry_lookahead_2bit (
    input  wire [1:0] g,    // generate signals for bit0 and bit1
    input  wire [1:0] p,    // propagate signals for bit0 and bit1
    input  wire       cin,  // carry-in to this 2-bit block
    output wire [1:0] c     // carry outputs c[0] = carry after bit0, c[1] = carry after bit1
);
    // c[0] is carry into bit1
    assign c[0] = g[0] | (p[0] & cin);
    // c[1] is carry out of the 2-bit block
    assign c[1] = g[1] | (p[1] & c[0]);
endmodule

// 8-bit adder combining bit-level full adders with 2-bit carry lookahead blocks
module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire [7:0] g, p;       // generate and propagate for each bit
    wire [7:0] c_internal; // internal carries between bits (c_internal[i] = carry out of bit i)
    wire [3:0] c_block;    // carry out from each 2-bit carry lookahead block

    // Step 1: Generate and propagate signals for each bit
    assign g = a & b;
    assign p = a ^ b;

    // Step 2: Carry lookahead and carry propagation at 2-bit block level
    // We have 4 blocks: bits [1:0], [3:2], [5:4], [7:6]

    wire [1:0] c_lookahead [3:0]; // internal carry signals inside each 2-bit block

    // Compute carries for block 0 (bits 1:0)
    carry_lookahead_2bit cla0 (
        .g(g[1:0]),
        .p(p[1:0]),
        .cin(cin),
        .c(c_lookahead[0])
    );
    assign c_block[0] = c_lookahead[0][1]; // carry out after bit 1

    // Compute carries for block 1 (bits 3:2)
    carry_lookahead_2bit cla1 (
        .g(g[3:2]),
        .p(p[3:2]),
        .cin(c_block[0]),
        .c(c_lookahead[1])
    );
    assign c_block[1] = c_lookahead[1][1]; // carry out after bit 3

    // Compute carries for block 2 (bits 5:4)
    carry_lookahead_2bit cla2 (
        .g(g[5:4]),
        .p(p[5:4]),
        .cin(c_block[1]),
        .c(c_lookahead[2])
    );
    assign c_block[2] = c_lookahead[2][1]; // carry out after bit 5

    // Compute carries for block 3 (bits 7:6)
    carry_lookahead_2bit cla3 (
        .g(g[7:6]),
        .p(p[7:6]),
        .cin(c_block[2]),
        .c(c_lookahead[3])
    );
    assign c_block[3] = c_lookahead[3][1]; // carry out after bit 7

    // Step 3: Assign internal carries for each bit to be used by full adders
    // Bit 0 carry-in is external cin
    assign c_internal[0] = c_lookahead[0][0]; // carry after bit 0
    assign c_internal[1] = c_lookahead[0][1]; // carry after bit 1 = c_block[0]

    assign c_internal[2] = c_lookahead[1][0] + (c_block[0] & ~c_lookahead[1][0]) ? 1'b1 : 1'b0; // will refine below
    // Wait, better assign explicitly:
    // c_internal[2] is carry after bit 2 = c_lookahead[1][0]
    assign c_internal[2] = c_lookahead[1][0];
    // c_internal[3] is carry after bit 3 = c_lookahead[1][1] = c_block[1]
    assign c_internal[3] = c_lookahead[1][1];

    assign c_internal[4] = c_lookahead[2][0];
    assign c_internal[5] = c_lookahead[2][1]; // c_block[2]

    assign c_internal[6] = c_lookahead[3][0];
    assign c_internal[7] = c_lookahead[3][1]; // c_block[3]

    // Step 4: Instantiate bit full adders with the appropriate carry-in signals
    // For bit 0, cin is input cin
    // For bit i>0, carry-in is c_internal[i-1]

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_fa
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(i == 0 ? cin : c_internal[i-1]),
                .sum(sum[i]),
                .cout() // cout not used here as carry handled externally
            );
        end
    endgenerate

    assign cout = c_internal[7]; // carry out of the most significant bit
endmodule