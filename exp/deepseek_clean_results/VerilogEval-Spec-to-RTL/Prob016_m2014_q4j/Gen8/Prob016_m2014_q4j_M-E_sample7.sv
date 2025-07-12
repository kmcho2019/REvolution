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
    wire carry;
    
    FullAdder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry)
    );
    
    FullAdder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(carry),
        .sum(sum[1]),
        .cout(cout)
    );
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2 bits (ripple carry)
    wire lower_carry;
    TwoBitAdder lower(
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(sum[1:0]),
        .cout(lower_carry)
    );
    
    // Upper 2 bits (carry-select)
    wire [1:0] sum_c0, sum_c1;
    wire cout_c0, cout_c1;
    
    // Compute upper bits with carry=0
    TwoBitAdder upper_c0(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b0),
        .sum(sum_c0),
        .cout(cout_c0)
    );
    
    // Compute upper bits with carry=1
    TwoBitAdder upper_c1(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b1),
        .sum(sum_c1),
        .cout(cout_c1)
    );
    
    // Select correct upper sum and carry based on lower carry
    assign sum[3:2] = lower_carry ? sum_c1 : sum_c0;
    assign sum[4] = lower_carry ? cout_c1 : cout_c0;
endmodule