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
    // Lower 2 bits (computed normally)
    wire lower_carry;
    wire [1:0] lower_sum;
    
    TwoBitAdder lower_adder(
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(lower_sum),
        .cout(lower_carry)
    );
    
    // Upper 2 bits (computed for both carry cases)
    wire [1:0] upper_sum0, upper_sum1;
    wire upper_cout0, upper_cout1;
    
    TwoBitAdder upper_adder0(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b0),
        .sum(upper_sum0),
        .cout(upper_cout0)
    );
    
    TwoBitAdder upper_adder1(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b1),
        .sum(upper_sum1),
        .cout(upper_cout1)
    );
    
    // Select correct upper result based on lower carry
    assign sum[1:0] = lower_sum;
    assign sum[3:2] = lower_carry ? upper_sum1 : upper_sum0;
    assign sum[4] = lower_carry ? upper_cout1 : upper_cout0;
endmodule