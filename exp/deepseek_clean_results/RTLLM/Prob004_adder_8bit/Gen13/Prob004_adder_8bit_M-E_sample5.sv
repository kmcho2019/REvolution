module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder
    wire [3:0] sum_low;
    wire carry_low;
    ripple_4bit adder_low (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum_low),
        .cout(carry_low)
    );

    // Upper 4-bit adders (both carry cases)
    wire [3:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    
    // Case when carry-in is 0
    ripple_4bit adder_high_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum_high_0),
        .cout(carry_high_0)
    );
    
    // Case when carry-in is 1
    ripple_4bit adder_high_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum_high_1),
        .cout(carry_high_1)
    );

    // Select correct upper sum and carry based on lower carry
    assign sum[3:0] = sum_low;
    assign sum[7:4] = carry_low ? sum_high_1 : sum_high_0;
    assign cout = carry_low ? carry_high_1 : carry_high_0;

endmodule

// 4-bit ripple-carry adder submodule
module ripple_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire c0, c1, c2;
    
    // Bit 0
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c0 = (a[0] & b[0]) | (cin & (a[0] | b[0]));
    
    // Bit 1
    assign sum[1] = a[1] ^ b[1] ^ c0;
    assign c1 = (a[1] & b[1]) | (c0 & (a[1] | b[1]));
    
    // Bit 2
    assign sum[2] = a[2] ^ b[2] ^ c1;
    assign c2 = (a[2] & b[2]) | (c1 & (a[2] | b[2]));
    
    // Bit 3
    assign sum[3] = a[3] ^ b[3] ^ c2;
    assign cout = (a[3] & b[3]) | (c2 & (a[3] | b[3]));
endmodule