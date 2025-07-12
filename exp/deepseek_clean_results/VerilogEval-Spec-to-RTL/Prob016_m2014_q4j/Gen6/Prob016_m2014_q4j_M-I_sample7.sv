module FullAdderOpt(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    wire ab, a_xor_b;
    assign ab = a & b;
    assign a_xor_b = a ^ b;
    assign sum = a_xor_b ^ cin;
    assign cout = ab | (a_xor_b & cin);  // Shared term optimization
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Carry-lookahead for first two bits
    wire g0 = x[0] & y[0];
    wire p0 = x[0] ^ y[0];
    wire c1 = g0;  // cin for bit1
    
    wire g1 = x[1] & y[1];
    wire p1 = x[1] ^ y[1];
    wire c2 = g1 | (p1 & c1);  // cin for bit2
    
    // Ripple-carry for remaining bits
    wire c3;
    
    FullAdderOpt fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout()  // c1 already computed
    );
    
    FullAdderOpt fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout()  // c2 already computed
    );
    
    FullAdderOpt fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(c2),
        .sum(sum[2]),
        .cout(c3)
    );
    
    FullAdderOpt fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(c3),
        .sum(sum[3]),
        .cout(sum[4])
    );
endmodule