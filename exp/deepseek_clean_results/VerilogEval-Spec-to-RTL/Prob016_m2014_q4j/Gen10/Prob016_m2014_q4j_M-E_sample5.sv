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
    // Lower 2 bits (regular ripple carry)
    wire carry_lower;
    wire [1:0] sum_lower;
    
    TwoBitAdder lower(
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(sum_lower),
        .cout(carry_lower)
    );
    
    // Upper 2 bits (carry-select)
    wire [1:0] sum_upper_c0, sum_upper_c1;
    wire carry_upper_c0, carry_upper_c1;
    
    // Compute upper bits for both carry cases
    TwoBitAdder upper_c0(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b0),
        .sum(sum_upper_c0),
        .cout(carry_upper_c0)
    );
    
    TwoBitAdder upper_c1(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b1),
        .sum(sum_upper_c1),
        .cout(carry_upper_c1)
    );
    
    // Select correct upper result based on actual carry
    assign sum[3:2] = carry_lower ? sum_upper_c1 : sum_upper_c0;
    assign sum[4] = carry_lower ? carry_upper_c1 : carry_upper_c0;
    
    // Assign lower sum bits
    assign sum[1:0] = sum_lower;
endmodule