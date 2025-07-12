module RippleCarryAdder #(
    parameter WIDTH = 4
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    output [WIDTH-1:0] sum,
    output             cout,
    output             p_block,  // block propagate: all bits propagate
    output             g_block   // block generate: block generates carry
);
    wire [WIDTH-1:0] p; // propagate per bit
    wire [WIDTH-1:0] g; // generate per bit
    wire [WIDTH:0] c;   // carry signals between bits

    assign c[0] = cin;

    genvar i;
    generate
        for(i=0; i<WIDTH; i=i+1) begin : bit_adder
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
            assign c[i+1] = g[i] | (p[i] & c[i]);
            assign sum[i] = p[i] ^ c[i];
        end
    endgenerate

    assign cout = c[WIDTH];

    // Block propagate = AND of all p[i]
    assign p_block = &p;

    // Block generate = g[WIDTH-1] OR (p[WIDTH-1] & g[WIDTH-2]) OR ... recursive:
    // Can be computed as:
    // g_block = g[WIDTH-1] | (p[WIDTH-1] & g[WIDTH-2]) | (p[WIDTH-1]&p[WIDTH-2]&g[WIDTH-3]) | ...
    // For WIDTH=4, explicitly:
    assign g_block =
          g[WIDTH-1]
        | (p[WIDTH-1] & g[WIDTH-2])
        | (p[WIDTH-1] & p[WIDTH-2] & g[WIDTH-3])
        | (p[WIDTH-1] & p[WIDTH-2] & p[WIDTH-3] & c[0]); 
    // Note: last term uses c[0] which is cin, for 4-bit block this covers full block generate chain

endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Lower 4-bit adder
    wire [3:0] sum_lower;
    wire       cout_lower, p_lower, g_lower;

    RippleCarryAdder #(.WIDTH(4)) lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(sum_lower),
        .cout(cout_lower),
        .p_block(p_lower),
        .g_block(g_lower)
    );

    // Calculate carry_in for upper block using carry-lookahead between blocks:
    // carry_in_upper = g_lower | (p_lower & cin_lower)
    // cin_lower = 0, so carry_in_upper = g_lower
    wire carry_in_upper = g_lower;

    // Upper 4-bit adder
    wire [3:0] sum_upper;
    wire       cout_upper, p_upper, g_upper;

    RippleCarryAdder #(.WIDTH(4)) upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_in_upper),
        .sum(sum_upper),
        .cout(cout_upper),
        .p_block(p_upper),
        .g_block(g_upper)
    );

    assign s = {sum_upper, sum_lower};

    // Overflow detection:
    // Overflow = carry into MSB XOR carry out of MSB
    // carry into MSB = c[7] inside upper_adder, which is the carry-in to bit 7
    // For upper_adder bits: bits 4..7, MSB is bit 3 of upper_adder
    // carry into MSB of upper_adder is c[3], which equals carry_out of bit 6

    // We do not have internal carry wires exposed, so recompute carry into MSB of upper block:
    // carry chain inside upper_adder:
    // c[0]_upper = carry_in_upper
    // c[1]_upper = g_upper[0] | (p_upper[0] & c[0]_upper)
    // c[2]_upper = g_upper[1] | (p_upper[1] & c[1]_upper)
    // c[3]_upper = g_upper[2] | (p_upper[2] & c[2]_upper)

    wire c1_upper = g_upper[0] | (p_upper[0] & carry_in_upper);
    wire c2_upper = g_upper[1] | (p_upper[1] & c1_upper);
    wire c3_upper = g_upper[2] | (p_upper[2] & c2_upper); // carry into MSB (bit 7)

    wire carry_in_msb = c3_upper;
    wire carry_out_msb = cout_upper;

    assign overflow = carry_in_msb ^ carry_out_msb;

endmodule