module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    wire [4:0] carry;
    
    assign carry[0] = Cin;
    
    // Optimized carry chain
    assign carry[1] = (a[0] & b[0]) | ((a[0] | b[0]) & carry[0]);
    assign carry[2] = (a[1] & b[1]) | ((a[1] | b[1]) & carry[1]);
    assign carry[3] = (a[2] & b[2]) | ((a[2] | b[2]) & carry[2]);
    assign carry[4] = (a[3] & b[3]) | ((a[3] | b[3]) & carry[3]);
    
    assign y = a ^ b ^ carry[3:0];
    assign Co = carry[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // First 4-bit ripple-carry adder (critical path starts here)
    wire carry0;
    wire [3:0] sum0;
    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(sum0),
        .Co(carry0)
    );
    
    // Next three 4-bit carry-select blocks
    wire carry1_0, carry1_1;
    wire [3:0] sum1_0, sum1_1;
    
    // Carry=0 case
    adder_4bit adder1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b0),
        .y(sum1_0),
        .Co(carry1_0)
    );
    
    // Carry=1 case
    adder_4bit adder1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b1),
        .y(sum1_1),
        .Co(carry1_1)
    );
    
    // Select results
    wire [3:0] sum1 = carry0 ? sum1_1 : sum1_0;
    wire carry1 = carry0 ? carry1_1 : carry1_0;
    
    // Repeat for next blocks
    wire carry2_0, carry2_1;
    wire [3:0] sum2_0, sum2_1;
    
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
    
    wire [3:0] sum2 = carry1 ? sum2_1 : sum2_0;
    wire carry2 = carry1 ? carry2_1 : carry2_0;
    
    // Final block
    wire carry3_0, carry3_1;
    wire [3:0] sum3_0, sum3_1;
    
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
    
    wire [3:0] sum3 = carry2 ? sum3_1 : sum3_0;
    wire carry3 = carry2 ? carry3_1 : carry3_0;
    
    // Combine all results
    assign y = {sum3, sum2, sum1, sum0};
    assign Co = carry3;
endmodule