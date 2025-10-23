module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] p; // propagate
    wire [7:0] g; // generate
    wire [7:1] c; // intermediate carry signals

    assign p = a ^ b;
    assign g = a & b;

    // Carry-lookahead logic for c[1] to c[7]
    // c[0] = Cin (input carry)
    // Use the formula:
    // c[i] = g[i-1] | (p[i-1] & c[i-1])
    // But here we expand carries in parallel:
    assign c[1] = g[0] | (p[0] & Cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & Cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & Cin);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0])
                  | (p[3] & p[2] & p[1] & p[0] & Cin);
    assign c[5] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1])
                  | (p[4] & p[3] & p[2] & p[1] & g[0]) | (p[4] & p[3] & p[2] & p[1] & p[0] & Cin);
    assign c[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2])
                  | (p[5] & p[4] & p[3] & p[2] & g[1])
                  | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                  | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & Cin);
    assign c[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3])
                  | (p[6] & p[5] & p[4] & p[3] & g[2])
                  | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
                  | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                  | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & Cin);

    // Carry out for the 8th bit (Co)
    assign Co = g[7] | (p[7] & c[7]);

    // Sum bits
    // c[0] = Cin
    assign y[0] = p[0] ^ Cin;
    assign y[1] = p[1] ^ c[1];
    assign y[2] = p[2] ^ c[2];
    assign y[3] = p[3] ^ c[3];
    assign y[4] = p[4] ^ c[4];
    assign y[5] = p[5] ^ c[5];
    assign y[6] = p[6] ^ c[6];
    assign y[7] = p[7] ^ c[7];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit lower_8 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper_8 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule