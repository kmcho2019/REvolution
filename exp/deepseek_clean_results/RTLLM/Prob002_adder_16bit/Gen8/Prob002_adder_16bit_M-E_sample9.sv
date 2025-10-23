module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output Pg,
    output Gg
);
    // Generate and propagate signals
    wire [3:0] G = a & b;
    wire [3:0] P = a ^ b;
    
    // Carry lookahead logic
    wire c1 = G[0] | (P[0] & Cin);
    wire c2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    wire c3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | 
              (P[2] & P[1] & P[0] & Cin);
    wire c4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
              (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);
    
    // Sum calculation
    assign sum[0] = P[0] ^ Cin;
    assign sum[1] = P[1] ^ c1;
    assign sum[2] = P[2] ^ c2;
    assign sum[3] = P[3] ^ c3;
    
    // Block propagate and generate
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
               (P[3] & P[2] & P[1] & G[0]);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Block 0 (bits 3:0)
    wire [3:0] sum0;
    wire Pg0, Gg0;
    adder_4bit_cla block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .sum(sum0),
        .Pg(Pg0),
        .Gg(Gg0)
    );
    
    // Block 1 (bits 7:4) - carry select
    wire [3:0] sum1_c0, sum1_c1;
    wire Pg1_c0, Gg1_c0, Pg1_c1, Gg1_c1;
    
    // Compute both possible scenarios (carry 0 and 1)
    adder_4bit_cla block1_c0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b0),
        .sum(sum1_c0),
        .Pg(Pg1_c0),
        .Gg(Gg1_c0)
    );
    
    adder_4bit_cla block1_c1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b1),
        .sum(sum1_c1),
        .Pg(Pg1_c1),
        .Gg(Gg1_c1)
    );
    
    // Select correct sum based on actual carry from block0
    wire carry0 = Gg0 | (Pg0 & Cin);
    wire [3:0] sum1 = carry0 ? sum1_c1 : sum1_c0;
    wire Pg1 = carry0 ? Pg1_c1 : Pg1_c0;
    wire Gg1 = carry0 ? Gg1_c1 : Gg1_c0;
    
    // Block 2 (bits 11:8) - carry select
    wire [3:0] sum2_c0, sum2_c1;
    wire Pg2_c0, Gg2_c0, Pg2_c1, Gg2_c1;
    
    adder_4bit_cla block2_c0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b0),
        .sum(sum2_c0),
        .Pg(Pg2_c0),
        .Gg(Gg2_c0)
    );
    
    adder_4bit_cla block2_c1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b1),
        .sum(sum2_c1),
        .Pg(Pg2_c1),
        .Gg(Gg2_c1)
    );
    
    // Select correct sum based on carry from block1
    wire carry1 = Gg1 | (Pg1 & carry0);
    wire [3:0] sum2 = carry1 ? sum2_c1 : sum2_c0;
    wire Pg2 = carry1 ? Pg2_c1 : Pg2_c0;
    wire Gg2 = carry1 ? Gg2_c1 : Gg2_c0;
    
    // Block 3 (bits 15:12) - carry select
    wire [3:0] sum3_c0, sum3_c1;
    
    adder_4bit_cla block3_c0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b0),
        .sum(sum3_c0),
        .Pg(),
        .Gg()
    );
    
    adder_4bit_cla block3_c1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b1),
        .sum(sum3_c1),
        .Pg(),
        .Gg()
    );
    
    // Select correct sum based on carry from block2
    wire carry2 = Gg2 | (Pg2 & carry1);
    wire [3:0] sum3 = carry2 ? sum3_c1 : sum3_c0;
    
    // Final carry out
    assign Co = carry2;
    
    // Combine all sums
    assign y = {sum3, sum2, sum1, sum0};
endmodule