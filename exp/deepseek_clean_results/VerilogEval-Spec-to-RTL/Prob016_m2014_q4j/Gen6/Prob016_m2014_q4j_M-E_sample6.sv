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
    wire carry_mid;
    
    FullAdder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry_mid)
    );
    
    FullAdder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(carry_mid),
        .sum(sum[1]),
        .cout(cout)
    );
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2 bits (always computed)
    wire lower_carry;
    wire [1:0] lower_sum;
    
    // Upper 2 bits (both carry cases computed in parallel)
    wire [1:0] upper_sum_c0;
    wire [1:0] upper_sum_c1;
    wire upper_cout_c0;
    wire upper_cout_c1;
    
    // Lower 2-bit adder
    TwoBitAdder lower(
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(lower_sum),
        .cout(lower_carry)
    );
    
    // Upper 2-bit adders (both carry cases)
    TwoBitAdder upper_c0(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b0),
        .sum(upper_sum_c0),
        .cout(upper_cout_c0)
    );
    
    TwoBitAdder upper_c1(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b1),
        .sum(upper_sum_c1),
        .cout(upper_cout_c1)
    );
    
    // Output muxing
    assign sum[1:0] = lower_sum;
    assign sum[3:2] = lower_carry ? upper_sum_c1 : upper_sum_c0;
    assign sum[4] = lower_carry ? upper_cout_c1 : upper_cout_c0;
endmodule