module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    wire c1, c2, c3;
    
    // Bit 0
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c1 = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
    
    // Bit 1
    assign y[1] = a[1] ^ b[1] ^ c1;
    assign c2 = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);
    
    // Bit 2
    assign y[2] = a[2] ^ b[2] ^ c2;
    assign c3 = (a[2] & b[2]) | (a[2] & c2) | (b[2] & c2);
    
    // Bit 3
    assign y[3] = a[3] ^ b[3] ^ c3;
    assign Co = (a[3] & b[3]) | (a[3] & c3) | (b[3] & c3);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Block 0 (bits 3:0) - always calculated with Cin
    wire [3:0] sum0;
    wire carry0;
    adder_4bit block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(sum0),
        .Co(carry0)
    );
    
    // Block 1 (bits 7:4) - calculate both possible sums
    wire [3:0] sum1_c0, sum1_c1;
    wire carry1_c0, carry1_c1;
    adder_4bit block1_c0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b0),
        .y(sum1_c0),
        .Co(carry1_c0)
    );
    adder_4bit block1_c1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b1),
        .y(sum1_c1),
        .Co(carry1_c1)
    );
    
    // Block 2 (bits 11:8) - calculate both possible sums
    wire [3:0] sum2_c0, sum2_c1;
    wire carry2_c0, carry2_c1;
    adder_4bit block2_c0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b0),
        .y(sum2_c0),
        .Co(carry2_c0)
    );
    adder_4bit block2_c1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b1),
        .y(sum2_c1),
        .Co(carry2_c1)
    );
    
    // Block 3 (bits 15:12) - calculate both possible sums
    wire [3:0] sum3_c0, sum3_c1;
    wire carry3_c0, carry3_c1;
    adder_4bit block3_c0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b0),
        .y(sum3_c0),
        .Co(carry3_c0)
    );
    adder_4bit block3_c1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b1),
        .y(sum3_c1),
        .Co(carry3_c1)
    );
    
    // Select logic for Block 1
    wire carry1;
    assign y[7:4] = carry0 ? sum1_c1 : sum1_c0;
    assign carry1 = carry0 ? carry1_c1 : carry1_c0;
    
    // Select logic for Block 2
    wire carry2;
    assign y[11:8] = carry1 ? sum2_c1 : sum2_c0;
    assign carry2 = carry1 ? carry2_c1 : carry2_c0;
    
    // Select logic for Block 3
    assign y[15:12] = carry2 ? sum3_c1 : sum3_c0;
    assign Co = carry2 ? carry3_c1 : carry3_c0;
    
    // Assign Block 0 output
    assign y[3:0] = sum0;
endmodule