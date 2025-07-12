module adder_8bit_cla (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] p, g;         // propagate and generate signals
    wire [7:1] c;            // internal carry signals

    assign p = a ^ b;        // propagate
    assign g = a & b;        // generate

    // Carry lookahead logic
    // c[0] = Cin (input carry)
    // c[1] = g[0] | (p[0] & c[0])
    // c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0])
    // c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0])
    // and so forth for c[4]..c[7]

    assign c[1] = g[0] | (p[0] & Cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & Cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & Cin);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & Cin);
    assign c[5] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1])
                  | (p[4] & p[3] & p[2] & p[1] & g[0]) | (p[4] & p[3] & p[2] & p[1] & p[0] & Cin);
    assign c[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2])
                  | (p[5] & p[4] & p[3] & p[2] & g[1]) | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                  | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & Cin);
    assign c[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3])
                  | (p[6] & p[5] & p[4] & p[3] & g[2]) | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
                  | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                  | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & Cin);

    // Final carry out
    assign Cout = g[7] | (p[7] & c[7]);

    // sum bits
    assign sum = p ^ {c[7:1], Cin};
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit_cla lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    adder_8bit_cla upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule