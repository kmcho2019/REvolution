module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire [7:0] p;        // propagate signals
    wire [7:0] g;        // generate signals
    wire [8:1] c;        // internal carry signals (c[1] is carry into bit 1)

    // Propagate and generate signals per bit
    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic: compute carry bits in parallel
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    // Sum bits: sum[i] = p[i] XOR carry-in for bit i
    assign sum = p ^ {c[7:1], cin};

    // Final carry out
    assign cout = c[8];

endmodule