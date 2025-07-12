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
    wire [1:0] sum_lower;
    wire [1:0] sum_upper0, sum_upper1;
    wire carry_lower;
    wire carry_upper0, carry_upper1;
    
    // Lower 2 bits (regular ripple carry)
    TwoBitAdder lower(
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(sum_lower),
        .cout(carry_lower)
    );
    
    // Upper 2 bits (both carry cases)
    TwoBitAdder upper0(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b0),
        .sum(sum_upper0),
        .cout(carry_upper0)
    );
    
    TwoBitAdder upper1(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b1),
        .sum(sum_upper1),
        .cout(carry_upper1)
    );
    
    // Mux selection based on lower carry
    assign sum[3:2] = carry_lower ? sum_upper1 : sum_upper0;
    assign sum[1:0] = sum_lower;
    assign sum[4] = carry_lower ? carry_upper1 : carry_upper0;
endmodule