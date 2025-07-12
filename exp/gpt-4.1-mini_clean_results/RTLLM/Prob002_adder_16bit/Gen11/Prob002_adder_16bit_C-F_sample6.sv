module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] p;    // propagate
    wire [7:0] g;    // generate
    wire [8:0] c;    // carry signals

    // Propagate and generate signals
    assign p = a ^ b;
    assign g = a & b;

    // Initial carry input
    assign c[0] = Cin;

    // Explicit carry computations for clarity
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    // Sum bits using generate for brevity
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_compute
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

    // Lower 8 bits adder instance
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    // Upper 8 bits adder instance
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule