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

// 4-bit block carry lookahead generator
module cla_4bit (
    input  wire [3:0] p,    // propagate
    input  wire [3:0] g,    // generate
    input  wire       cin,  // carry-in
    output wire [4:1] c     // carries c1 to c4
);
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);
endmodule

// 8-bit adder using two 4-bit blocks and carry lookahead between blocks
module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire [3:0] p0, g0; // propagate and generate for lower 4 bits
    wire [3:0] p1, g1; // propagate and generate for upper 4 bits
    wire [4:1] c0, c1; // carries inside blocks
    wire c4;           // carry out from lower 4-bit block (carry into upper block)

    // Instantiate full adders for lower 4 bits
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : lower_block
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(i == 0 ? cin : c0[i]),
                .sum(sum[i]),
                .cout()
            );
            assign p0[i] = a[i] ^ b[i];       // propagate = a XOR b
            assign g0[i] = a[i] & b[i];       // generate = a AND b
        end
    endgenerate

    // Generate carries c1 to c4 in lower block using CLA
    cla_4bit cla_lower (
        .p(p0),
        .g(g0),
        .cin(cin),
        .c(c0)
    );

    // Connect sum's carry-in for bit 1 to c0[1], bit 2 to c0[2], bit 3 to c0[3]
    // We re-assign sum bits again here to use carries from CLA for correct sum bits 
    // because initial instantiation used incomplete carry for bits 1-3.
    // So full sums with correct carries:
    generate
        for (i = 1; i < 4; i = i + 1) begin : lower_sum_update
            bit_full_adder fa_update (
                .a(a[i]),
                .b(b[i]),
                .cin(c0[i]),
                .sum(sum[i]),
                .cout()
            );
        end
    endgenerate

    assign c4 = c0[4]; // carry-out from lower block

    // Instantiate full adders for upper 4 bits
    generate
        for (i = 4; i < 8; i = i + 1) begin : upper_block
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(i == 4 ? c4 : c1[i-4]),
                .sum(sum[i]),
                .cout()
            );
            assign p1[i-4] = a[i] ^ b[i];       // propagate for upper bits
            assign g1[i-4] = a[i] & b[i];       // generate for upper bits
        end
    endgenerate

    // Generate carries c5 to c8 (c1[1]..c1[4]) in upper block using CLA
    cla_4bit cla_upper (
        .p(p1),
        .g(g1),
        .cin(c4),
        .c(c1)
    );

    // Update sums bits 5..7 using correct carry values similarly as lower block
    generate
        for (i = 5; i < 8; i = i + 1) begin : upper_sum_update
            bit_full_adder fa_update (
                .a(a[i]),
                .b(b[i]),
                .cin(c1[i-4]),
                .sum(sum[i]),
                .cout()
            );
        end
    endgenerate

    assign cout = c1[4]; // carry out from upper 4-bit block, final cout

endmodule