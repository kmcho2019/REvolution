module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Calculate generate signals (g_i = a_i * b_i)
    wire [7:0] g;
    assign g[0] = a[0] & b[0];
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign g[i] = a[i] & b[i];
        end
    endgenerate

    // Calculate propagate signals (p_i = a_i ^ b_i)
    wire [7:0] p;
    assign p[0] = a[0] ^ b[0];
    generate
        for (i = 1; i < 8; i++) begin
            assign p[i] = a[i] ^ b[i];
        end
    endgenerate

    // Calculate carry signals using carry-lookahead logic
    wire [7:0] c;
    assign c[0] = cin;
    generate
        for (i = 1; i < 8; i++) begin
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    // Calculate sum signals
    assign sum[0] = a[0] ^ b[0] ^ cin;
    generate
        for (i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ c[i];
        end
    endgenerate

    // Calculate final carry-out
    assign cout = g[7] | (p[7] & c[7]);

endmodule