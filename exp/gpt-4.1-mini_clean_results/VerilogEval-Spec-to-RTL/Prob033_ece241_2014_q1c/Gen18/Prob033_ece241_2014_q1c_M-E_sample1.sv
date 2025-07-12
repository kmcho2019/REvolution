module Add4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire [3:0] p = a ^ b;    // propagate
    wire [3:0] g = a & b;    // generate
    wire c1, c2, c3;

    assign c1 = g[0] | (p[0] & cin);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign cout = g[3] | (p[3] & c3);
    assign sum = p ^ {c3, c2, c1, cin};
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire c4;

    // Lower 4 bits adder
    Add4bit lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(s[3:0]),
        .cout(c4)
    );

    // Upper 4 bits adder
    Add4bit upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(s[7:4]),
        .cout()  // not used for overflow detection here
    );

    // Overflow detection for 2's complement: 
    // overflow if sign of a and b are same but sign of sum differs
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule