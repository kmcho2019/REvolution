module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    wire [4:0] sum;
    
    assign sum = a + b + Cin;
    assign y = sum[3:0];
    assign Co = sum[4];
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
    wire carry0;
    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(sum0),
        .Co(carry0)
    );
    
    // Segment 1 (bits 7:4) - carry-select
    wire [3:0] sum1_0, sum1_1;
    wire carry1_0, carry1_1;
    adder_4bit adder1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b0),
        .y(sum1_0),
        .Co(carry1_0)
    );
    adder_4bit adder1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b1),
        .y(sum1_1),
        .Co(carry1_1)
    );
    wire [3:0] sum1;
    wire carry1;
    assign sum1 = carry0 ? sum1_1 : sum1_0;
    assign carry1 = carry0 ? carry1_1 : carry1_0;
    
    // Segment 2 (bits 11:8) - carry-select
    wire [3:0] sum2_0, sum2_1;
    wire carry2_0, carry2_1;
    adder_4bit adder2_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b0),
        .y(sum2_0),
        .Co(carry2_0)
    );
    adder_4bit adder2_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b1),
        .y(sum2_1),
        .Co(carry2_1)
    );
    wire [3:0] sum2;
    wire carry2;
    assign sum2 = carry1 ? sum2_1 : sum2_0;
    assign carry2 = carry1 ? carry2_1 : carry2_0;
    
    // Segment 3 (bits 15:12) - carry-select
    wire [3:0] sum3_0, sum3_1;
    wire carry3_0, carry3_1;
    adder_4bit adder3_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b0),
        .y(sum3_0),
        .Co(carry3_0)
    );
    adder_4bit adder3_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b1),
        .y(sum3_1),
        .Co(carry3_1)
    );
    wire [3:0] sum3;
    assign sum3 = carry2 ? sum3_1 : sum3_0;
    assign Co = carry2 ? carry3_1 : carry3_0;
    
    // Combine all segments
    assign y = {sum3, sum2, sum1, sum0};
endmodule