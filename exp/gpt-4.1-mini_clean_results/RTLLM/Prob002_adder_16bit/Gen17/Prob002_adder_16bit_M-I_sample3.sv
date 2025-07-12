module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] p, g;          // propagate and generate signals
    wire [8:0] c;             // carry signals including input and output

    assign p = a ^ b;         // propagate = a XOR b
    assign g = a & b;         // generate  = a AND b
    assign c[0] = Cin;

    // Carry lookahead logic for 8 bits
    // Compute carries in parallel using CLA equations:
    // c[1] = g[0] | (p[0] & c[0])
    // c[2] = g[1] | (p[1] & g[0]) | (p[1]&p[0]&c[0])
    // and so forth...

    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[5] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) | 
                  (p[4] & p[3] & p[2] & p[1] & g[0]) | (p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2]) | 
                  (p[5] & p[4] & p[3] & p[2] & g[1]) | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | 
                  (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3]) | 
                  (p[6] & p[5] & p[4] & p[3] & g[2]) | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | 
                  (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | 
                  (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[8] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]) | 
                  (p[7] & p[6] & p[5] & p[4] & g[3]) | (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) | 
                  (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | 
                  (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                  (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_gen
            assign sum[i] = p[i] ^ c[i];
        end
    endgenerate

    assign Cout = c[8];
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    // Instantiate lower 8-bit CLA
    adder_8bit adder_lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    // Instantiate upper 8-bit CLA
    adder_8bit adder_upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule