module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout,
    output p  // propagate signal
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    assign p = a ^ b;  // propagate signal
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [1:0] p;
    wire [2:1] carry;
    wire skip_carry;
    
    // First 2-bit block (standard ripple-carry)
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[1]),
        .p(p[0])
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[1]),
        .sum(sum[1]),
        .cout(carry[2]),
        .p(p[1])
    );
    
    // Skip logic
    assign skip_carry = (p[0] & p[1]) ? carry[1] : carry[2];
    
    // Second 2-bit block
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(skip_carry),
        .sum(sum[2]),
        .cout(),  // unused intermediate carry
        .p()      // unused in this block
    );
    
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(skip_carry),
        .sum(sum[3]),
        .cout(sum[4]),
        .p()      // unused in this block
    );
endmodule