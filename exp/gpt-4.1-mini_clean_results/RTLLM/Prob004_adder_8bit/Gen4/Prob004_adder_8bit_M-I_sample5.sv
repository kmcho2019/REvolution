module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire g,    // generate signal
    output wire p     // propagate signal
);
    // generate and propagate signals
    assign g = a & b;
    assign p = a ^ b;
    // sum = p XOR cin
    assign sum = p ^ cin;
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] g;  // generate
    wire [7:0] p;  // propagate
    wire [8:0] c;  // carry signals

    assign c[0] = cin;

    // Instantiate bit-level adders
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_bitfa
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .g(g[i]),
                .p(p[i])
            );
        end
    endgenerate

    // Carry Lookahead Logic
    // c[i+1] = g[i] + p[i] * c[i]
    // Compute all carries in parallel to reduce delay

    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    assign cout = c[8];

endmodule