module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);

    wire [7:0] p;  // propagate signals
    wire [7:0] g;  // generate signals
    wire [7:0] c;  // internal carries

    // Generate propagate and generate signals
    assign p = a ^ b;      // propagate = a XOR b
    assign g = a & b;      // generate = a AND b

    // Calculate carries using ripple-carry logic
    assign c[0] = g[0] | (p[0] & cin);
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);
    assign c[4] = g[4] | (p[4] & c[3]);
    assign c[5] = g[5] | (p[5] & c[4]);
    assign c[6] = g[6] | (p[6] & c[5]);
    assign c[7] = g[7] | (p[7] & c[6]);

    // Sum bits calculation: sum_i = p_i XOR carry_in_i
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c[0];
    assign sum[2] = p[2] ^ c[1];
    assign sum[3] = p[3] ^ c[2];
    assign sum[4] = p[4] ^ c[3];
    assign sum[5] = p[5] ^ c[4];
    assign sum[6] = p[6] ^ c[5];
    assign sum[7] = p[7] ^ c[6];

    // Final carry out is carry generated at MSB
    assign cout = c[7];

endmodule