module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] carry;
    
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_adder
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    assign cout = carry[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Segment 0 (bits 3:0)
    wire [3:0] sum0;
    wire cout0;
    adder_4bit seg0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(sum0),
        .cout(cout0)
    );
    
    // Segment 1 (bits 7:4) - with carry-select
    wire [3:0] sum1_0, sum1_1;
    wire cout1_0, cout1_1;
    adder_4bit seg1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum1_0),
        .cout(cout1_0)
    );
    adder_4bit seg1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum1_1),
        .cout(cout1_1)
    );
    wire [3:0] sum1 = cout0 ? sum1_1 : sum1_0;
    wire cout1 = cout0 ? cout1_1 : cout1_0;
    
    // Segment 2 (bits 11:8) - with carry-select
    wire [3:0] sum2_0, sum2_1;
    wire cout2_0, cout2_1;
    adder_4bit seg2_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(sum2_0),
        .cout(cout2_0)
    );
    adder_4bit seg2_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b1),
        .sum(sum2_1),
        .cout(cout2_1)
    );
    wire [3:0] sum2 = cout1 ? sum2_1 : sum2_0;
    wire cout2 = cout1 ? cout2_1 : cout2_0;
    
    // Segment 3 (bits 15:12) - with carry-select
    wire [3:0] sum3_0, sum3_1;
    wire cout3_0, cout3_1;
    adder_4bit seg3_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b0),
        .sum(sum3_0),
        .cout(cout3_0)
    );
    adder_4bit seg3_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b1),
        .sum(sum3_1),
        .cout(cout3_1)
    );
    wire [3:0] sum3 = cout2 ? sum3_1 : sum3_0;
    wire cout3 = cout2 ? cout3_1 : cout3_0;
    
    // Combine all segments
    assign y = {sum3, sum2, sum1, sum0};
    assign Co = cout3;
endmodule