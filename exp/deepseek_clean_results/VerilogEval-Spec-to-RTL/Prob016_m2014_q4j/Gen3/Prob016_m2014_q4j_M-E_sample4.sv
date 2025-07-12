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
    // Lower 2 bits (regular ripple carry)
    wire [1:0] sum_low;
    wire carry_low;
    
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum_low[0]),
        .cout(sum[4])  // Temporary storage for carry0
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(sum[4]),  // carry0
        .sum(sum_low[1]),
        .cout(carry_low)
    );
    
    // Upper 2 bits (carry-select)
    wire [1:0] sum_high_c0;  // Result if carry_in = 0
    wire [1:0] sum_high_c1;  // Result if carry_in = 1
    wire carry_high_c0, carry_high_c1;
    
    // Upper bits with carry_in = 0
    FullAdder fa2_c0(
        .a(x[2]),
        .b(y[2]),
        .cin(1'b0),
        .sum(sum_high_c0[0]),
        .cout(carry_high_c0)
    );
    
    FullAdder fa3_c0(
        .a(x[3]),
        .b(y[3]),
        .cin(carry_high_c0),
        .sum(sum_high_c0[1]),
        .cout(carry_high_c0)
    );
    
    // Upper bits with carry_in = 1
    FullAdder fa2_c1(
        .a(x[2]),
        .b(y[2]),
        .cin(1'b1),
        .sum(sum_high_c1[0]),
        .cout(carry_high_c1)
    );
    
    FullAdder fa3_c1(
        .a(x[3]),
        .b(y[3]),
        .cin(carry_high_c1),
        .sum(sum_high_c1[1]),
        .cout(carry_high_c1)
    );
    
    // Mux selection based on carry from lower bits
    assign sum[3:2] = carry_low ? sum_high_c1 : sum_high_c0;
    assign sum[1:0] = sum_low;
    assign sum[4] = carry_low ? carry_high_c1 : carry_high_c0;
endmodule