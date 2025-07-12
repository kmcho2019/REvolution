module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] g = a & b;
    wire [3:0] p = a ^ b;
    wire [4:0] carry;
    
    assign carry[0] = cin;
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);
    assign carry[4] = g[3] | (p[3] & carry[3]);
    
    assign sum = p ^ carry[3:0];
    assign cout = carry[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // First 4-bit adder (ripple-carry)
    wire [3:0] sum0;
    wire cout0;
    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(sum0),
        .cout(cout0)
    );
    
    // Next three 4-bit adders implemented as carry-select
    wire [3:0] sum1_0, sum1_1;
    wire cout1_0, cout1_1;
    adder_4bit adder1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum1_0),
        .cout(cout1_0)
    );
    adder_4bit adder1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum1_1),
        .cout(cout1_1)
    );
    
    wire [3:0] sum2_0, sum2_1;
    wire cout2_0, cout2_1;
    adder_4bit adder2_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(sum2_0),
        .cout(cout2_0)
    );
    adder_4bit adder2_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b1),
        .sum(sum2_1),
        .cout(cout2_1)
    );
    
    wire [3:0] sum3_0, sum3_1;
    wire cout3_0, cout3_1;
    adder_4bit adder3_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b0),
        .sum(sum3_0),
        .cout(cout3_0)
    );
    adder_4bit adder3_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b1),
        .sum(sum3_1),
        .cout(cout3_1)
    );
    
    // Carry propagation and output selection
    wire sel1 = cout0;
    wire [3:0] sum1 = sel1 ? sum1_1 : sum1_0;
    wire cout1 = sel1 ? cout1_1 : cout1_0;
    
    wire sel2 = cout1;
    wire [3:0] sum2 = sel2 ? sum2_1 : sum2_0;
    wire cout2 = sel2 ? cout2_1 : cout2_0;
    
    wire sel3 = cout2;
    wire [3:0] sum3 = sel3 ? sum3_1 : sum3_0;
    wire cout3 = sel3 ? cout3_1 : cout3_0;
    
    // Final output assignment
    assign y = {sum3, sum2, sum1, sum0};
    assign Co = cout3;
endmodule