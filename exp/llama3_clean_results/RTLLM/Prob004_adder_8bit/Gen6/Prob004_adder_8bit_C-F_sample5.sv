module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry lookahead
wire [7:0] g; // Generate signals
wire [7:0] p; // Propagate signals
wire [8:0] c; // Carry signals, including cin

// Initialize carry-in
assign c[0] = cin;

// Generate and propagate signals, and calculate carry signals
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] ^ b[i];
        if (i == 0) begin
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end else begin
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    end
endgenerate

// Sum signals
generate
    for (i = 0; i < 8; i++) begin
        if (i == 0) begin
            assign sum[i] = a[i] ^ b[i] ^ c[i];
        end else begin
            assign sum[i] = a[i] ^ b[i] ^ c[i];
        end
    end
endgenerate

// Carry out
assign cout = c[8];

endmodule