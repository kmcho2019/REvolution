module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] carry;
    assign carry[0] = cin;
    
    // Ripple-carry implementation for base 4-bit adder
    assign carry[1] = (a[0] & b[0]) | ((a[0] | b[0]) & carry[0]);
    assign carry[2] = (a[1] & b[1]) | ((a[1] | b[1]) & carry[1]);
    assign carry[3] = (a[2] & b[2]) | ((a[2] | b[2]) & carry[2]);
    assign carry[4] = (a[3] & b[3]) | ((a[3] | b[3]) & carry[3]);
    
    assign sum = a ^ b ^ carry[3:0];
    assign cout = carry[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Base ripple-carry block (bits 0-3)
    wire cout0;
    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(y[3:0]),
        .cout(cout0)
    );
    
    // Carry-select blocks (bits 4-15)
    wire cout1_0, cout1_1;
    wire [3:0] sum1_0, sum1_1;
    
    // Block 1 (bits 4-7) with carry=0 and carry=1
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
    
    // Mux for block 1
    assign y[7:4] = cout0 ? sum1_1 : sum1_0;
    wire cout1 = cout0 ? cout1_1 : cout1_0;
    
    // Block 2 (bits 8-11)
    wire cout2_0, cout2_1;
    wire [3:0] sum2_0, sum2_1;
    
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
    
    // Mux for block 2
    assign y[11:8] = cout1 ? sum2_1 : sum2_0;
    wire cout2 = cout1 ? cout2_1 : cout2_0;
    
    // Block 3 (bits 12-15)
    wire cout3_0, cout3_1;
    wire [3:0] sum3_0, sum3_1;
    
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
    
    // Mux for block 3
    assign y[15:12] = cout2 ? sum3_1 : sum3_0;
    assign Co = cout2 ? cout3_1 : cout3_0;
endmodule