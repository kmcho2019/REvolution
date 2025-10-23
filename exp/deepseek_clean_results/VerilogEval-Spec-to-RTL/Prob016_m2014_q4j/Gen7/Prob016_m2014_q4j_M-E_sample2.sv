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
    wire [1:0] lower_sum;
    wire lower_cout;
    wire [1:0] upper_sum0, upper_sum1;
    wire upper_cout0, upper_cout1;
    
    // Lower 2-bit ripple-carry adder
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
        .cin(lower_sum[0]),
        .sum(lower_sum[1]),
        .cout(lower_cout)
    );
    
    // Upper 2-bit adders (for both carry-in cases)
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
        .cin(upper_sum0[0]),
        .sum(upper_sum0[1]),
        .cout(upper_cout0)
    );
    
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
        .cin(upper_sum1[0]),
        .sum(upper_sum1[1]),
        .cout(upper_cout1)
    );
    
    // Combine results
    assign sum[0] = lower_sum[0];
    assign sum[1] = lower_sum[1];
    assign sum[2] = lower_cout ? upper_sum1[0] : upper_sum0[0];
    assign sum[3] = lower_cout ? upper_sum1[1] : upper_sum0[1];
    assign sum[4] = lower_cout ? upper_cout1 : upper_cout0;
endmodule