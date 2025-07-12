module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] carry;
    
    assign carry[0] = cin;
    assign sum = a ^ b ^ carry[3:0];
    assign carry[4:1] = (a & b) | (a & carry[3:0]) | (b & carry[3:0]);
    assign cout = carry[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // First 4-bit adder (ripple carry)
    wire carry0;
    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(y[3:0]),
        .cout(carry0)
    );
    
    // Next three 4-bit adders with carry-select
    wire [2:0] carry1_0, carry1_1;
    wire [11:0] sum1_0, sum1_1;
    
    // Compute both possibilities for each stage
    adder_4bit adder1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum1_0[3:0]),
        .cout(carry1_0[0])
    );
    
    adder_4bit adder1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum1_1[3:0]),
        .cout(carry1_1[0])
    );
    
    adder_4bit adder2_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(sum1_0[7:4]),
        .cout(carry1_0[1])
    );
    
    adder_4bit adder2_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b1),
        .sum(sum1_1[7:4]),
        .cout(carry1_1[1])
    );
    
    adder_4bit adder3_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b0),
        .sum(sum1_0[11:8]),
        .cout(carry1_0[2])
    );
    
    adder_4bit adder3_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b1),
        .sum(sum1_1[11:8]),
        .cout(carry1_1[2])
    );
    
    // Select appropriate sums and carries
    wire carry1 = carry1_0[0] | (carry1_1[0] & carry0);
    wire carry2 = carry1_0[1] | (carry1_1[1] & carry1);
    wire carry3 = carry1_0[2] | (carry1_1[2] & carry2);
    
    assign y[7:4] = carry0 ? sum1_1[3:0] : sum1_0[3:0];
    assign y[11:8] = carry1 ? sum1_1[7:4] : sum1_0[7:4];
    assign y[15:12] = carry2 ? sum1_1[11:8] : sum1_0[11:8];
    assign Co = carry3;
endmodule