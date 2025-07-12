module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry lookahead
wire [7:0] g, p; // Generate and propagate signals
wire [7:0] c; // Carry signals

// Generate and propagate signals
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end
endgenerate

// Carry signals using lookahead logic
assign c[0] = g[0] | (p[0] & cin);
generate
    for (i = 1; i < 8; i++) begin
        assign c[i] = g[i] | (p[i] & c[i-1]);
    end
endgenerate

// Sum signals using half adders and full adders
assign sum[0] = a[0] ^ b[0] ^ cin;
generate
    for (i = 1; i < 8; i++) begin
        assign sum[i] = a[i] ^ b[i] ^ c[i-1];
    end
endgenerate

// Carry out
assign cout = g[7] | (p[7] & c[6]);

endmodule