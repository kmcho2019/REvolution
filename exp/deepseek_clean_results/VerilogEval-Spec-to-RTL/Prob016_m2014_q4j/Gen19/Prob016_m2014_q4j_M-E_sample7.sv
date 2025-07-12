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

module BlockAdder(
    input [1:0] a,
    input [1:0] b,
    input cin,
    output [1:0] sum,
    output cout,
    output prop
);
    wire [1:0] carry;
    
    // First bit in block
    FullAdder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );
    
    // Second bit in block
    FullAdder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(cout)
    );
    
    // Block propagation signal (P = a[0]^b[0] & a[1]^b[1])
    assign prop = (a[0] ^ b[0]) & (a[1] ^ b[1]);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire block0_cout, block1_cout;
    wire block0_prop, block1_prop;
    wire skip_carry;
    
    // Lower 2-bit block (bits 1:0)
    BlockAdder block0(
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(sum[1:0]),
        .cout(block0_cout),
        .prop(block0_prop)
    );
    
    // Skip logic: if block0 propagates, use its cout, else bypass
    assign skip_carry = block0_prop ? block0_cout : 1'b0;
    
    // Upper 2-bit block (bits 3:2)
    BlockAdder block1(
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(skip_carry),
        .sum(sum[3:2]),
        .cout(sum[4]),
        .prop(block1_prop)
    );
endmodule