module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

wire [7:0] g;  // Generate signal
wire [7:0] p;  // Propagate signal
wire [7:0] c;  // Carry signal

// Calculate generate and propagate signals
genvar i;
for (i = 0; i < 8; i++) begin
    assign g[i] = a[i] & b[i];
    assign p[i] = a[i] | b[i];
end

// Calculate carry signals using carry-lookahead approach
assign c[0] = g[0] | (p[0] & cin);
for (i = 1; i < 8; i++) begin
    assign c[i] = g[i] | (p[i] & c[i-1]);
end

// Calculate sum using XOR operation
assign sum[0] = a[0] ^ b[0] ^ cin;
for (i = 1; i < 8; i++) begin
    assign sum[i] = a[i] ^ b[i] ^ c[i-1];
end

// Calculate carry-out
assign cout = g[7] | (p[7] & c[6]);

endmodule