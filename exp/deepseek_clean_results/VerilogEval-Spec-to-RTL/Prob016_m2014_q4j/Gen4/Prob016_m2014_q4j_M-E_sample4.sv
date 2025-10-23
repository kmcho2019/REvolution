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

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2 bits (ripple carry)
    wire lower_carry;
    wire [1:0] lower_sum;
    
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(lower_sum[0]),
        .cout()
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(1'b0),
        .sum(lower_sum[1]),
        .cout(lower_carry)
    );
    
    // Upper 2 bits (carry-select)
    wire [1:0] upper_sum0, upper_sum1;
    wire upper_carry0, upper_carry1;
    
    // Upper bits with carry-in 0
    FullAdder fa2_0(
        .a(x[2]),
        .b(y[2]),
        .cin(1'b0),
        .sum(upper_sum0[0]),
        .cout()
    );
    
    FullAdder fa3_0(
        .a(x[3]),
        .b(y[3]),
        .cin(1'b0),
        .sum(upper_sum0[1]),
        .cout(upper_carry0)
    );
    
    // Upper bits with carry-in 1
    FullAdder fa2_1(
        .a(x[2]),
        .b(y[2]),
        .cin(1'b1),
        .sum(upper_sum1[0]),
        .cout()
    );
    
    FullAdder fa3_1(
        .a(x[3]),
        .b(y[3]),
        .cin(1'b1),
        .sum(upper_sum1[1]),
        .cout(upper_carry1)
    );
    
    // Select correct upper sum and carry
    wire [1:0] upper_sum = lower_carry ? upper_sum1 : upper_sum0;
    wire upper_carry = lower_carry ? upper_carry1 : upper_carry0;
    
    // Combine results
    assign sum[1:0] = lower_sum;
    assign sum[3:2] = upper_sum;
    assign sum[4] = upper_carry;
endmodule