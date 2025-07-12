module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout,
    output p  // propagate signal (a XOR b)
);
    assign p = a ^ b;
    assign sum = p ^ cin;
    assign cout = (a & b) | (p & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [1:0] p;       // Propagate signals for each block
    wire [1:0] block_c;  // Block carry outputs
    wire skip_carry;     // Skip carry signal
    
    // First 2-bit block (bits 0-1)
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
    
    // Skip logic: if both bits propagate, carry skips this block
    assign skip_carry = p[0] & p[1];
    
    // Second 2-bit block (bits 2-3) with carry select
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(skip_carry ? block_c[1] : block_c[0]),
        .sum(sum[2]),
        .cout(sum[4]),  // Final carry-out
        .p()  // Not needed for last block
    );
    
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(sum[4]),  // Chain from previous adder
        .sum(sum[3]),
        .cout(),  // Not used
        .p()      // Not used
    );
endmodule