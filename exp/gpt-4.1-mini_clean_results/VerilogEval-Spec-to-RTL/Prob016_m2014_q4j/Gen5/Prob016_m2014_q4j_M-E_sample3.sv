module FullAdder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TwoBitAdder (
    input  [1:0] a,
    input  [1:0] b,
    input        cin,
    output [1:0] sum,
    output       cout
);
    wire carry_internal;
    
    FullAdder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry_internal)
    );
    
    FullAdder fa1 (
        .a(a[1]),
        .b(b[1]),
        .cin(carry_internal),
        .sum(sum[1]),
        .cout(cout)
    );
endmodule

module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire carry_mid;
    wire [1:0] sum_low;
    wire [1:0] sum_high;
    
    // Lower 2-bit adder
    TwoBitAdder lower_adder (
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(carry_mid)
    );
    
    // Upper 2-bit adder
    TwoBitAdder upper_adder (
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(carry_mid),
        .sum(sum_high),
        .cout(sum[4])
    );
    
    assign sum[1:0] = sum_low;
    assign sum[3:2] = sum_high;
endmodule