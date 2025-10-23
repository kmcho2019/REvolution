module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] p, g, c;

    // Generate p and g signals
    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    assign c[0] = cin;

    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    // Generate sum signals
    assign sum[0] = p[0] ^ c[0];
    genvar j;
    generate
        for (j = 1; j < 8; j++) begin
            assign sum[j] = p[j] ^ c[j];
        end
    endgenerate

    // Generate final carry out
    assign cout = g[7] | (p[7] & c[7]);

endmodule