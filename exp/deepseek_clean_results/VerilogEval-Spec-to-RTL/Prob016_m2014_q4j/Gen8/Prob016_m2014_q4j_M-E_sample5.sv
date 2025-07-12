module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
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
    // Lower 2 bits (always compute with carry-in 0)
    wire [1:0] sum_low;
    wire cout_low;
    
    TwoBitAdder low_adder(
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(cout_low)
    );
    
    // Upper 2 bits - compute both possible carry-in scenarios
    wire [1:0] sum_high_c0;
    wire [1:0] sum_high_c1;
    wire cout_high_c0;
    wire cout_high_c1;
    
    TwoBitAdder high_adder_c0(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b0),
        .sum(sum_high_c0),
        .cout(cout_high_c0)
    );
    
    TwoBitAdder high_adder_c1(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b1),
        .sum(sum_high_c1),
        .cout(cout_high_c1)
    );
    
    // Select correct upper sum and carry based on lower carry-out
    assign sum[3:2] = cout_low ? sum_high_c1 : sum_high_c0;
    assign sum[4] = cout_low ? cout_high_c1 : cout_high_c0;
    
    // Lower sum is always correct
    assign sum[1:0] = sum_low;
endmodule