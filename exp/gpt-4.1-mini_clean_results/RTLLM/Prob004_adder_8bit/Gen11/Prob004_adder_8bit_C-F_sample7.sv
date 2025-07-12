// Single bit full adder with propagate and generate outputs
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire p,     // propagate
    output wire g      // generate
);
    assign p   = a ^ b;
    assign g   = a & b;
    assign sum = p ^ cin;
endmodule

// 4-bit carry look-ahead adder using bit_full_adder blocks
module adder_4bit_cla (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [3:0] p;      // propagate signals
    wire [3:0] g;      // generate signals
    wire [4:0] c;      // carry signals

    assign c[0] = cin;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : gen_fa
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .p(p[i]),
                .g(g[i])
            );
        end
    endgenerate

    // Carry look-ahead logic for 4 bits:
    // c[i+1] = g[i] | (p[i] & c[i])

    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign cout = c[4];
endmodule

// Top-level 8-bit adder using two 4-bit CLA blocks connected by carry
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire carry_mid;

    // Lower 4-bit CLA adder
    adder_4bit_cla lower (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(carry_mid)
    );

    // Upper 4-bit CLA adder
    adder_4bit_cla upper (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_mid),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule