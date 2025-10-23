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
    wire [1:0] block_propagate;
    wire [2:0] carry;
    wire skip_enable;
    
    // Compute propagate signals for each bit
    assign block_propagate[0] = x[0] ^ y[0];
    assign block_propagate[1] = x[1] ^ y[1];
    
    // Skip condition: when entire block propagates carry
    assign skip_enable = block_propagate[0] & block_propagate[1];
    
    // First 2-bit block (standard ripple-carry)
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );
    
    // Carry skip mux
    wire carry_to_block2 = skip_enable ? carry[0] : carry[1];
    
    // Second 2-bit block
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(carry_to_block2),
        .sum(sum[2]),
        .cout(carry[2])
    );
    
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(sum[4])
    );
endmodule