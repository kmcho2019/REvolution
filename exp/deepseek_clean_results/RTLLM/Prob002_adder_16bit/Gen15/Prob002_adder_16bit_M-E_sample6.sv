module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co,
    output Pg,  // Group propagate
    output Gg   // Group generate
);
    wire [3:0] p, g;
    wire [4:0] c;
    
    // Generate and propagate terms
    assign p = a ^ b;
    assign g = a & b;
    
    // Carry lookahead logic
    assign c[0] = Cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                 (p[3] & p[2] & p[1] & p[0] & c[0]);
    
    // Sum and outputs
    assign y = p ^ c[3:0];
    assign Co = c[4];
    assign Pg = &p;  // Group propagate
    assign Gg = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Stage 1: Four 4-bit blocks with carry-select
    wire [3:0] sum0_0, sum0_1, sum1_0, sum1_1, sum2_0, sum2_1, sum3_0, sum3_1;
    wire co0_0, co0_1, co1_0, co1_1, co2_0, co2_1, co3_0, co3_1;
    wire pg0, pg1, pg2, pg3;
    wire gg0, gg1, gg2, gg3;
    
    // Block 0 (LSB) - no carry-select needed
    adder_4bit_cla block0 (
        .a(a[3:0]), .b(b[3:0]), .Cin(Cin),
        .y(y[3:0]), .Co(co0_0), .Pg(pg0), .Gg(gg0)
    );
    
    // Other blocks compute both possible sums
    // Block 1 (Cin=0)
    adder_4bit_cla block1_0 (
        .a(a[7:4]), .b(b[7:4]), .Cin(1'b0),
        .y(sum1_0), .Co(co1_0), .Pg(pg1), .Gg(gg1)
    );
    // Block 1 (Cin=1)
    adder_4bit_cla block1_1 (
        .a(a[7:4]), .b(b[7:4]), .Cin(1'b1),
        .y(sum1_1), .Co(co1_1), .Pg(), .Gg()
    );
    
    // Block 2 (Cin=0)
    adder_4bit_cla block2_0 (
        .a(a[11:8]), .b(b[11:8]), .Cin(1'b0),
        .y(sum2_0), .Co(co2_0), .Pg(pg2), .Gg(gg2)
    );
    // Block 2 (Cin=1)
    adder_4bit_cla block2_1 (
        .a(a[11:8]), .b(b[11:8]), .Cin(1'b1),
        .y(sum2_1), .Co(co2_1), .Pg(), .Gg()
    );
    
    // Block 3 (Cin=0)
    adder_4bit_cla block3_0 (
        .a(a[15:12]), .b(b[15:12]), .Cin(1'b0),
        .y(sum3_0), .Co(co3_0), .Pg(pg3), .Gg(gg3)
    );
    // Block 3 (Cin=1)
    adder_4bit_cla block3_1 (
        .a(a[15:12]), .b(b[15:12]), .Cin(1'b1),
        .y(sum3_1), .Co(co3_1), .Pg(), .Gg()
    );
    
    // Carry-select muxes
    wire carry1, carry2, carry3;
    
    assign carry1 = co0_0;
    assign y[7:4] = carry1 ? sum1_1 : sum1_0;
    
    assign carry2 = carry1 ? co1_1 : co1_0;
    assign y[11:8] = carry2 ? sum2_1 : sum2_0;
    
    assign carry3 = carry2 ? co2_1 : co2_0;
    assign y[15:12] = carry3 ? sum3_1 : sum3_0;
    
    // Final carry out
    assign Co = carry3 ? co3_1 : co3_0;
endmodule