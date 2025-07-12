module adder_nbit #(parameter WIDTH = 8)
(
    input   [WIDTH-1:0] a,
    input   [WIDTH-1:0] b,
    input       cin,
    output  [WIDTH-1:0] sum,
    output      cout
);

// Internal signals for carry lookahead
wire [WIDTH-1:0] g, p; // Generate and propagate signals
wire [WIDTH-1:0] c; // Carry signals

// Generate and propagate signals
genvar i;
generate
    for (i = 0; i < WIDTH; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end
endgenerate

// Carry signals using lookahead logic
assign c[0] = g[0] | (p[0] & cin);
generate
    for (i = 1; i < WIDTH; i++) begin
        assign c[i] = g[i] | (p[i] & c[i-1]);
    end
endgenerate

// Sum signals using half adders and full adders
assign sum[0] = a[0] ^ b[0] ^ cin;
generate
    for (i = 1; i < WIDTH; i++) begin
        assign sum[i] = a[i] ^ b[i] ^ c[i-1];
    end
endgenerate

// Carry out
assign cout = g[WIDTH-1] | (p[WIDTH-1] & c[WIDTH-2]);

endmodule