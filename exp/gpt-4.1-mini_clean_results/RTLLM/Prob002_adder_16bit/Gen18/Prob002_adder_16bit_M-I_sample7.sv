module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co,
    output       P,   // Block propagate
    output       G    // Block generate
);
    wire [7:0] p, g;
    wire [8:0] carry;

    assign p = a ^ b;       // Propagate signals
    assign g = a & b;       // Generate signals
    assign carry[0] = Cin;  // Initial carry-in

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_chain
            assign carry[i+1] = g[i] | (p[i] & carry[i]);
        end
    endgenerate

    assign y = p ^ carry[7:0]; // Sum bits = propagate xor carry-in
    assign Co = carry[8];      // Final carry out

    // Block propagate is AND of all bit propagates (all must propagate)
    assign P = &p;

    // Block generate is G7 or (P7 and G6) or ... or (P7&P6&...P0 and Cin)
    // But since we don't have Cin here, the block generate is true if the block will generate carry regardless of carry-in
    // For 8-bit adder, block generate G = g7 + p7g6 + p7p6g5 + ... + p7p6...p0g0
    // To avoid complex logic, approximate block generate as carry[8] when carry[0]=0, so we compute:
    // block generate = g7 | (p7 & g6) | (p7 & p6 & g5) | ... | (p7 & p6 & ... & p0 & 0)
    // It's easier to compute as carry with Cin=0:
    wire [7:0] carry_no_cin;
    wire [8:0] carry_tmp;
    assign carry_tmp[0] = 1'b0; // Cin=0
    generate
        for (i = 0; i < 8; i = i +1) begin : carry_no_cin_gen
            assign carry_tmp[i+1] = g[i] | (p[i] & carry_tmp[i]);
        end
    endgenerate
    assign G = carry_tmp[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire P_lower, G_lower;
    wire carry_mid;

    // Lower 8-bit adder instance
    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(),    // not used directly
        .P(P_lower),
        .G(G_lower)
    );

    // Compute carry-in to upper 8-bit adder using block carry-lookahead
    assign carry_mid = G_lower | (P_lower & Cin);

    wire P_upper, G_upper;

    // Upper 8-bit adder instance
    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co),
        .P(P_upper),
        .G(G_upper)
    );
endmodule