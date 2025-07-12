// 8-bit carry lookahead adder with direct propagate and generate signal computation
module cla_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] p;  // propagate signals
    wire [7:0] g;  // generate signals
    wire [8:1] c;  // carry signals: c[i] is carry into bit i
    
    // Compute propagate and generate signals directly
    assign p = a ^ b;
    assign g = a & b;

    // Compute carries hierarchically
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    // Compute sum bits
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c[1];
    assign sum[2] = p[2] ^ c[2];
    assign sum[3] = p[3] ^ c[3];
    assign sum[4] = p[4] ^ c[4];
    assign sum[5] = p[5] ^ c[5];
    assign sum[6] = p[6] ^ c[6];
    assign sum[7] = p[7] ^ c[7];

    assign cout = c[8];
endmodule

// Top-level 8-bit adder using the above 8-bit CLA module
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    cla_8bit cla_inst (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
endmodule