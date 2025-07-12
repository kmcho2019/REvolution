module FullAdderWithPropagate(
    input a,
    input b,
    input cin,
    output sum,
    output cout,
    output p
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    assign p = a ^ b;  // Propagate signal for carry-skip logic
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [1:0] carry;  // Group carries
    wire [1:0] group_p; // Group propagate signals
    
    // First 2-bit group
    FullAdderWithPropagate fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0]),
        .p(group_p[0])
    );
    
    FullAdderWithPropagate fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1]),
        .p(group_p[1])
    );
    
    // Carry-skip logic
    wire group0_propagate = group_p[0] & group_p[1];
    wire skip_carry = group0_propagate ? carry[0] : carry[1];
    
    // Second 2-bit group
    FullAdderWithPropagate fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(skip_carry),
        .sum(sum[2]),
        .cout(carry[2]),
        .p(group_p[2])
    );
    
    FullAdderWithPropagate fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(sum[4]),
        .p(group_p[3])
    );
endmodule