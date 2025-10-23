module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    wire axorb = a ^ b;
    assign sum = axorb ^ cin;
    assign cout = (a & b) | (axorb & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [2:0] c;  // Carry chain for bits 0-2
    
    // Bit 0 (LSB)
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(c[0])
    );
    
    // Bit 1
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(c[0]),
        .sum(sum[1]),
        .cout(c[1])
    );
    
    // Bit 2
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(c[1]),
        .sum(sum[2]),
        .cout(c[2])
    );
    
    // Bit 3 (MSB) with carry-lookahead optimization
    wire g = x[3] & y[3];
    wire p = x[3] ^ y[3];
    assign sum[3] = p ^ c[2];
    assign sum[4] = g | (p & c[2]);
endmodule