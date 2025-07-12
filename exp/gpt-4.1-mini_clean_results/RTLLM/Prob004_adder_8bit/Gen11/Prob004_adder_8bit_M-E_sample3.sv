// Single bit full adder module (same as before, modular)
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire axb;
    assign axb  = a ^ b;
    assign sum  = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

// 8-bit adder with parallel carry computation via propagate/generate logic
module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire [7:0] p;   // propagate signals
    wire [7:0] g;   // generate signals
    wire [8:0] carry; // carry signals, carry[0] = cin

    assign carry[0] = cin;

    // Generate and Propagate signals for each bit
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_pg
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
        end
    endgenerate

    // Parallel carry computation (carry lookahead logic)
    // carry[i+1] = g[i] | (p[i] & carry[i])

    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);
    assign carry[4] = g[3] | (p[3] & carry[3]);
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & carry[5]);
    assign carry[7] = g[6] | (p[6] & carry[6]);
    assign carry[8] = g[7] | (p[7] & carry[7]);

    // Instantiate full adders for each bit with computed carries
    bit_full_adder fa0 (.a(a[0]), .b(b[0]), .cin(carry[0]), .sum(sum[0]), .cout());
    bit_full_adder fa1 (.a(a[1]), .b(b[1]), .cin(carry[1]), .sum(sum[1]), .cout());
    bit_full_adder fa2 (.a(a[2]), .b(b[2]), .cin(carry[2]), .sum(sum[2]), .cout());
    bit_full_adder fa3 (.a(a[3]), .b(b[3]), .cin(carry[3]), .sum(sum[3]), .cout());
    bit_full_adder fa4 (.a(a[4]), .b(b[4]), .cin(carry[4]), .sum(sum[4]), .cout());
    bit_full_adder fa5 (.a(a[5]), .b(b[5]), .cin(carry[5]), .sum(sum[5]), .cout());
    bit_full_adder fa6 (.a(a[6]), .b(b[6]), .cin(carry[6]), .sum(sum[6]), .cout());
    bit_full_adder fa7 (.a(a[7]), .b(b[7]), .cin(carry[7]), .sum(sum[7]), .cout());

    assign cout = carry[8];

endmodule