// 1-bit full adder module (bit-level adder)
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

// 4-bit ripple carry adder using bit_full_adder modules
module rca_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout,
    output wire       p_block, // block propagate
    output wire       g_block  // block generate
);
    wire [3:0] c; // internal carry signals, c[0] is cin input carry

    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_full_adders
            if (i == 0) begin
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(c[0]),
                    .sum(sum[i]),
                    .cout(c[1])
                );
            end else begin
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(c[i]),
                    .sum(sum[i]),
                    .cout(c[i+1])
                );
            end
        end
    endgenerate

    assign cout = c[4];

    // Block propagate: all bits propagate carry
    assign p_block = (&(a ^ b));

    // Block generate: carry generated internally within the block or from cin
    // g_block = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0
    // Compute propagate and generate per bit for block carry logic
    wire [3:0] p; // propagate bits
    wire [3:0] g; // generate bits
    assign p = a ^ b;
    assign g = a & b;

    assign g_block = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

// Top-level 8-bit adder with hierarchical carry lookahead between 4-bit ripple blocks
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    // Wires for block propagate and generate from lower 4-bit block
    wire p_lo, g_lo;
    // Carry into upper 4-bit block, computed by carry lookahead between blocks
    wire c4;

    // Lower 4-bit ripple carry adder block
    rca_4bit lower_block (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(/* unused, internal carry out c[4]*/),
        .p_block(p_lo),
        .g_block(g_lo)
    );

    // Carry lookahead for c4 (carry into upper block)
    assign c4 = g_lo | (p_lo & cin);

    // Upper 4-bit ripple carry adder block
    wire p_hi, g_hi;
    rca_4bit upper_block (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(sum[7:4]),
        .cout(cout),
        .p_block(p_hi),
        .g_block(g_hi)
    );
endmodule