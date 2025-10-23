module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co,
    output G,
    output P
);
    // Compound generate/propagate terms
    wire [3:0] g = a & b;
    wire [3:0] p = a ^ b;
    
    // Block generate/propagate
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign P = p[3] & p[2] & p[1] & p[0];
    
    // Carry calculation
    wire [4:0] c;
    assign c[0] = Cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    
    assign y = p ^ c[3:0];
    assign Co = c[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Block 0 (bits 3:0)
    wire co0, G0, P0;
    adder_4bit_cla block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(co0),
        .G(G0),
        .P(P0)
    );
    
    // Block 1 (bits 7:4) - carry-select implementation
    wire co1_0, G1_0, P1_0;
    wire co1_1, G1_1, P1_1;
    wire [3:0] y1_0, y1_1;
    
    // Block1 with carry=0
    adder_4bit_cla block1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b0),
        .y(y1_0),
        .Co(co1_0),
        .G(G1_0),
        .P(P1_0)
    );
    
    // Block1 with carry=1
    adder_4bit_cla block1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b1),
        .y(y1_1),
        .Co(co1_1),
        .G(G1_1),
        .P(P1_1)
    );
    
    // Select correct version
    wire sel1 = co0;
    assign y[7:4] = sel1 ? y1_1 : y1_0;
    wire co1 = sel1 ? co1_1 : co1_0;
    wire G1 = sel1 ? G1_1 : G1_0;
    wire P1 = sel1 ? P1_1 : P1_0;
    
    // Block 2 (bits 11:8) - carry-select implementation
    wire co2_0, G2_0, P2_0;
    wire co2_1, G2_1, P2_1;
    wire [3:0] y2_0, y2_1;
    
    adder_4bit_cla block2_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b0),
        .y(y2_0),
        .Co(co2_0),
        .G(G2_0),
        .P(P2_0)
    );
    
    adder_4bit_cla block2_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b1),
        .y(y2_1),
        .Co(co2_1),
        .G(G2_1),
        .P(P2_1)
    );
    
    wire sel2 = G1 | (P1 & co0);
    assign y[11:8] = sel2 ? y2_1 : y2_0;
    wire co2 = sel2 ? co2_1 : co2_0;
    wire G2 = sel2 ? G2_1 : G2_0;
    wire P2 = sel2 ? P2_1 : P2_0;
    
    // Block 3 (bits 15:12) - carry-select implementation
    wire co3_0, G3_0, P3_0;
    wire co3_1, G3_1, P3_1;
    wire [3:0] y3_0, y3_1;
    
    adder_4bit_cla block3_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b0),
        .y(y3_0),
        .Co(co3_0),
        .G(G3_0),
        .P(P3_0)
    );
    
    adder_4bit_cla block3_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b1),
        .y(y3_1),
        .Co(co3_1),
        .G(G3_1),
        .P(P3_1)
    );
    
    wire sel3 = G2 | (P2 & G1) | (P2 & P1 & co0);
    assign y[15:12] = sel3 ? y3_1 : y3_0;
    assign Co = sel3 ? co3_1 : co3_0;
endmodule