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
    wire [1:0] p;       // propagate signals for each block
    wire [1:0] block_c; // block carry outputs
    wire skip_carry;    // skip carry signal
    
    // First 2-bit block
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(block_c[0]),
        .p(p[0])
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(block_c[0]),
        .sum(sum[1]),
        .cout(block_c[1]),
        .p(p[1])
    );
    
    // Carry skip logic
    assign skip_carry = p[0] & p[1];
    
    // Second 2-bit block with carry select
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(skip_carry ? block_c[1] : block_c[0]),
        .sum(sum[2]),
        .cout(sum[4]),  // final carry is sum[4]
        .p()  // not used in second block
    );
    
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(sum[4]),    // chain from previous adder
        .sum(sum[3]),
        .cout(),         // unused
        .p()            // unused
    );
endmodule