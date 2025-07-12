module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] p; // propagate signals
    wire [7:0] g; // generate signals
    wire [7:0] c; // carries

    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic
    assign c[0] = (g[0]) | (p[0] & Cin);
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);
    assign c[4] = g[4] | (p[4] & c[3]);
    assign c[5] = g[5] | (p[5] & c[4]);
    assign c[6] = g[6] | (p[6] & c[5]);
    assign c[7] = g[7] | (p[7] & c[6]);

    // sum bits: y[i] = p[i] ^ carry_in
    assign y[0] = p[0] ^ Cin;
    genvar i;
    generate
        for(i = 1; i < 8; i = i + 1) begin : sum_bits
            assign y[i] = p[i] ^ c[i-1];
        end
    endgenerate

    assign Co = c[7];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule