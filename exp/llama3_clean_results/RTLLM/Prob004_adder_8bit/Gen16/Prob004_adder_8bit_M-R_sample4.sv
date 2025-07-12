module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

    wire [7:0] g, p;
    wire [7:0] c;

    // Calculate generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    assign sum[0] = a[0] ^ b[0] ^ cin;

    // Calculate carry signals
    assign c[0] = g[0] | (p[0] & cin);

    // Calculate generate, propagate, and sum signals for bits 1-7
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
            assign sum[i] = a[i] ^ b[i] ^ c[i-1];
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    // Assign carry-out
    assign cout = c[7];

endmodule