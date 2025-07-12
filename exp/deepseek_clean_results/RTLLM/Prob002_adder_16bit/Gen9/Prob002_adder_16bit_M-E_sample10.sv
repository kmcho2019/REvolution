module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] carry;
    assign carry[0] = cin;
    
    // 4-bit ripple carry adder
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);
    
    assign sum[1] = a[1] ^ b[1] ^ carry[1];
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry[1]) | (b[1] & carry[1]);
    
    assign sum[2] = a[2] ^ b[2] ^ carry[2];
    assign carry[3] = (a[2] & b[2]) | (a[2] & carry[2]) | (b[2] & carry[2]);
    
    assign sum[3] = a[3] ^ b[3] ^ carry[3];
    assign carry[4] = (a[3] & b[3]) | (a[3] & carry[3]) | (b[3] & carry[3]);
    
    assign cout = carry[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Carry signals between blocks
    wire carry0, carry1, carry2;
    wire carry1_0, carry1_1;  // Possible carries for block1
    wire carry2_0, carry2_1;  // Possible carries for block2
    wire carry3_0, carry3_1;  // Possible carries for block3
    
    // Sum signals for carry-select blocks
    wire [3:0] sum1_0, sum1_1;
    wire [3:0] sum2_0, sum2_1;
    wire [3:0] sum3_0, sum3_1;
    
    // First 4-bit block (always ripple)
    adder_4bit block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(y[3:0]),
        .cout(carry0)
    );
    
    // Second 4-bit block (carry-select)
    adder_4bit block1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum1_0),
        .cout(carry1_0)
    );
    
    adder_4bit block1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum1_1),
        .cout(carry1_1)
    );
    
    assign y[7:4] = carry0 ? sum1_1 : sum1_0;
    assign carry1 = carry0 ? carry1_1 : carry1_0;
    
    // Third 4-bit block (carry-select)
    adder_4bit block2_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(sum2_0),
        .cout(carry2_0)
    );
    
    adder_4bit block2_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b1),
        .sum(sum2_1),
        .cout(carry2_1)
    );
    
    assign y[11:8] = carry1 ? sum2_1 : sum2_0;
    assign carry2 = carry1 ? carry2_1 : carry2_0;
    
    // Fourth 4-bit block (carry-select)
    adder_4bit block3_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b0),
        .sum(sum3_0),
        .cout(carry3_0)
    );
    
    adder_4bit block3_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b1),
        .sum(sum3_1),
        .cout(carry3_1)
    );
    
    assign y[15:12] = carry2 ? sum3_1 : sum3_0;
    assign Co = carry2 ? carry3_1 : carry3_0;
endmodule