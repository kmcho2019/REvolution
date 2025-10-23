module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] g = a & b;  // generate
    wire [3:0] p = a | b;  // propagate
    wire [4:0] c;
    
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    
    assign sum = a ^ b ^ c[3:0];
    assign cout = c[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // First 4-bit block (ripple carry)
    wire cout0;
    adder_4bit block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(y[3:0]),
        .cout(cout0)
    );
    
    // Next three 4-bit blocks (carry-select)
    wire [3:0] sum1_0, sum1_1;
    wire [3:0] sum2_0, sum2_1;
    wire [3:0] sum3_0, sum3_1;
    wire cout1_0, cout1_1;
    wire cout2_0, cout2_1;
    wire cout3_0, cout3_1;
    
    // Block 1 (bits 4-7)
    adder_4bit block1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum1_0),
        .cout(cout1_0)
    );
    
    adder_4bit block1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum1_1),
        .cout(cout1_1)
    );
    
    // Block 2 (bits 8-11)
    adder_4bit block2_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(sum2_0),
        .cout(cout2_0)
    );
    
    adder_4bit block2_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b1),
        .sum(sum2_1),
        .cout(cout2_1)
    );
    
    // Block 3 (bits 12-15)
    adder_4bit block3_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b0),
        .sum(sum3_0),
        .cout(cout3_0)
    );
    
    adder_4bit block3_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b1),
        .sum(sum3_1),
        .cout(cout3_1)
    );
    
    // Carry-select muxes
    wire sel1 = cout0;
    assign y[7:4] = sel1 ? sum1_1 : sum1_0;
    wire cout1 = sel1 ? cout1_1 : cout1_0;
    
    wire sel2 = cout1;
    assign y[11:8] = sel2 ? sum2_1 : sum2_0;
    wire cout2 = sel2 ? cout2_1 : cout2_0;
    
    wire sel3 = cout2;
    assign y[15:12] = sel3 ? sum3_1 : sum3_0;
    assign Co = sel3 ? cout3_1 : cout3_0;
endmodule