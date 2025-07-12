// Single-bit full adder with propagate and generate outputs
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire p,    // propagate = a XOR b
    output wire g     // generate = a AND b
);
    wire axb;
    assign axb = a ^ b;
    assign sum = axb ^ cin;
    assign p   = axb;
    assign g   = a & b;
endmodule

// 8-bit adder with generate loop and carry look-ahead logic
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] p;   // propagate signals
    wire [7:0] g;   // generate signals
    wire [8:0] c;   // carry signals, c[0] = cin, c[8] = cout

    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : fa_gen
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

    // Carry look-ahead logic computed in parallel
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