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
    wire [3:1] carry;  // Intermediate carries
    wire group0_prop, group1_prop;
    wire carry_skip;
    
    // Group 0 (bits 1:0)
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[1])
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[1]),
        .sum(sum[1]),
        .cout(carry[2])
    );
    
    // Group propagation logic
    assign group0_prop = (x[0] ^ y[0]) & (x[1] ^ y[1]);  // Both bits propagate
    
    // Group 1 (bits 3:2)
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(group0_prop ? carry[2] : 1'b0),  // Skip if group doesn't propagate
        .sum(sum[2]),
        .cout(carry[3])
    );
    
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry[3]),
        .sum(sum[3]),
        .cout(sum[4])  // Overflow bit
    );
    
    // Final carry-out is sum[4]
endmodule