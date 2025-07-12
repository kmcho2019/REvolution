module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | ((a ^ b) & cin);
endmodule

module TwoBitAdder(
    input [1:0] a,
    input [1:0] b,
    input cin,
    output [1:0] sum,
    output cout
);
    wire carry0;
    
    FullAdder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry0)
    );
    
    FullAdder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(carry0),
        .sum(sum[1]),
        .cout(cout)
    );
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2-bit adder (bits 0-1)
    wire [1:0] sum_low;
    wire carry_low;
    
    TwoBitAdder lower(
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(carry_low)
    );
    
    // Upper 2-bit adders (bits 2-3) with both possible carry-ins
    wire [1:0] sum_high_c0, sum_high_c1;
    wire carry_high_c0, carry_high_c1;
    
    TwoBitAdder upper_c0(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b0),
        .sum(sum_high_c0),
        .cout(carry_high_c0)
    );
    
    TwoBitAdder upper_c1(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b1),
        .sum(sum_high_c1),
        .cout(carry_high_c1)
    );
    
    // Select correct upper result based on actual carry from lower
    assign sum[1:0] = sum_low;
    assign sum[3:2] = carry_low ? sum_high_c1 : sum_high_c0;
    assign sum[4] = carry_low ? carry_high_c1 : carry_high_c0;
endmodule