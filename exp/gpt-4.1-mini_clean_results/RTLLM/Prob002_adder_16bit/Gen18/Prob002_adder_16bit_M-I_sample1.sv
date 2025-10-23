module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co,
    output       Pout,
    output       Gout
);
    wire [7:0] p; // propagate
    wire [7:0] g; // generate
    wire [8:0] c; // carries

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = Cin;

    // Carry lookahead inside 8-bit block
    // c[i+1] = g[i] | (p[i] & c[i])

    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : carry_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign y = p ^ c[7:0];
    assign Co = c[8];

    // Block propagate: Pout = p0 & p1 & ... & p7
    assign Pout = &p;

    // Block generate: Gout = g7 + p7*g6 + p7*p6*g5 + ... + p7*...*p0*c0
    // Here we expand carry-out in terms of g and p:

    // To implement Gout efficiently:
    // Gout = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | ... | (p[7]&...&p[0] & c0)
    // Since c0 = Cin, here for block generate (independent of Cin),
    // Gout = g[7] | (p[7]&g[6]) | (p[7]&p[6]&g[5]) | ... | (p[7]&p[6]&...&p[1]&g[0])
    // This is called carry generate for the block, independent of Cin.
    // Implement with a chain:

    wire gcarry_0 = g[0];
    wire gcarry_1 = g[1] | (p[1] & gcarry_0);
    wire gcarry_2 = g[2] | (p[2] & gcarry_1);
    wire gcarry_3 = g[3] | (p[3] & gcarry_2);
    wire gcarry_4 = g[4] | (p[4] & gcarry_3);
    wire gcarry_5 = g[5] | (p[5] & gcarry_4);
    wire gcarry_6 = g[6] | (p[6] & gcarry_5);
    wire gcarry_7 = g[7] | (p[7] & gcarry_6);

    assign Gout = gcarry_7;
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid; // carry between lower and upper 8-bit adders
    wire P0, G0;    // propagate and generate from lower 8-bit adder
    wire P1, G1;    // propagate and generate from upper 8-bit adder

    // Instantiate lower 8-bit adder
    adder_8bit u_lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(),       // Not used here
        .Pout(P0),
        .Gout(G0)
    );

    // Calculate carry for upper 8-bit adder using CLA logic
    // carry_mid = G0 | (P0 & Cin)
    assign carry_mid = G0 | (P0 & Cin);

    // Instantiate upper 8-bit adder
    adder_8bit u_upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co),
        .Pout(P1),
        .Gout(G1)
    );
endmodule