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
    wire [1:0] p;       // Group propagate signals
    wire [1:0] g;       // Group generate signals
    wire [1:0] c;       // Group carry-out signals
    wire skip_carry;    // Skip carry between groups
    
    // First 2-bit group (bits 1:0)
    assign p[0] = (x[0] ^ y[0]) & (x[1] ^ y[1]);  // Both bits propagate
    assign g[0] = (x[0] & y[0]) | ((x[0] ^ y[0]) & (x[1] & y[1]));  // Group generate
    
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(c[0])
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(c[0]),
        .sum(sum[1]),
        .cout()
    );
    
    // Skip logic: if p[0]=1, carry skips first group
    assign skip_carry = p[0] ? c[0] : g[0];
    
    // Second 2-bit group (bits 3:2)
    assign p[1] = (x[2] ^ y[2]) & (x[3] ^ y[3]);  // Both bits propagate
    assign g[1] = (x[2] & y[2]) | ((x[2] ^ y[2]) & (x[3] & y[3]));  // Group generate
    
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(skip_carry),
        .sum(sum[2]),
        .cout(c[1])
    );
    
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(c[1]),
        .sum(sum[3]),
        .cout(sum[4])
    );
endmodule