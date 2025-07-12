module adder_5bit (
    input [4:0] a,
    input [4:0] b,
    input cin,
    output [4:0] sum,
    output cout
);
    wire [4:0] carry;
    
    assign carry[0] = (a[0] & b[0]) | ((a[0] | b[0]) & cin);
    assign carry[1] = (a[1] & b[1]) | ((a[1] | b[1]) & carry[0]);
    assign carry[2] = (a[2] & b[2]) | ((a[2] | b[2]) & carry[1]);
    assign carry[3] = (a[3] & b[3]) | ((a[3] | b[3]) & carry[2]);
    assign carry[4] = (a[4] & b[4]) | ((a[4] | b[4]) & carry[3]);
    
    assign sum = a ^ b ^ {carry[3:0], cin};
    assign cout = carry[4];
endmodule

module adder_6bit (
    input [5:0] a,
    input [5:0] b,
    input cin,
    output [5:0] sum,
    output cout
);
    wire [5:0] carry;
    
    assign carry[0] = (a[0] & b[0]) | ((a[0] | b[0]) & cin);
    assign carry[1] = (a[1] & b[1]) | ((a[1] | b[1]) & carry[0]);
    assign carry[2] = (a[2] & b[2]) | ((a[2] | b[2]) & carry[1]);
    assign carry[3] = (a[3] & b[3]) | ((a[3] | b[3]) & carry[2]);
    assign carry[4] = (a[4] & b[4]) | ((a[4] | b[4]) & carry[3]);
    assign carry[5] = (a[5] & b[5]) | ((a[5] | b[5]) & carry[4]);
    
    assign sum = a ^ b ^ {carry[4:0], cin};
    assign cout = carry[5];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // First 5-bit block
    wire cout_5bit;
    wire [4:0] sum_5bit;
    
    adder_5bit block0 (
        .a(a[4:0]),
        .b(b[4:0]),
        .cin(Cin),
        .sum(sum_5bit),
        .cout(cout_5bit)
    );
    
    // Second 5-bit block with carry-select
    wire cout_5bit_0, cout_5bit_1;
    wire [4:0] sum_5bit_0, sum_5bit_1;
    
    adder_5bit block1_0 (
        .a(a[9:5]),
        .b(b[9:5]),
        .cin(1'b0),
        .sum(sum_5bit_0),
        .cout(cout_5bit_0)
    );
    
    adder_5bit block1_1 (
        .a(a[9:5]),
        .b(b[9:5]),
        .cin(1'b1),
        .sum(sum_5bit_1),
        .cout(cout_5bit_1)
    );
    
    wire [4:0] sum_5bit_sel;
    wire cout_5bit_sel;
    
    assign sum_5bit_sel = cout_5bit ? sum_5bit_1 : sum_5bit_0;
    assign cout_5bit_sel = cout_5bit ? cout_5bit_1 : cout_5bit_0;
    
    // Final 6-bit block with carry-select
    wire cout_6bit_0, cout_6bit_1;
    wire [5:0] sum_6bit_0, sum_6bit_1;
    
    adder_6bit block2_0 (
        .a(a[15:10]),
        .b(b[15:10]),
        .cin(1'b0),
        .sum(sum_6bit_0),
        .cout(cout_6bit_0)
    );
    
    adder_6bit block2_1 (
        .a(a[15:10]),
        .b(b[15:10]),
        .cin(1'b1),
        .sum(sum_6bit_1),
        .cout(cout_6bit_1)
    );
    
    wire [5:0] sum_6bit_sel;
    
    assign sum_6bit_sel = cout_5bit_sel ? sum_6bit_1 : sum_6bit_0;
    assign Co = cout_5bit_sel ? cout_6bit_1 : cout_6bit_0;
    
    // Combine all sums
    assign y = {sum_6bit_sel, sum_5bit_sel, sum_5bit};
endmodule