module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry lookahead
wire [7:0] g, p;
wire [7:0] c;
wire [7:0] sum_wire;

// Generate and propagate signals
assign g[0] = a[0] & b[0];
assign p[0] = a[0] | b[0];
assign c[0] = g[0] | (p[0] & cin);

// Calculate generate and propagate signals
genvar i;
generate
    for (i = 1; i < 8; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end
endgenerate

// Calculate carry signals
assign c[1] = g[1] | (p[1] & c[0]);
assign c[2] = g[2] | (p[2] & c[1]);
assign c[3] = g[3] | (p[3] & c[2]);
assign c[4] = g[4] | (p[4] & c[3]);
assign c[5] = g[5] | (p[5] & c[4]);
assign c[6] = g[6] | (p[6] & c[5]);
assign c[7] = g[7] | (p[7] & c[6]);

// Calculate sum signals
assign sum_wire[0] = a[0] ^ b[0] ^ cin;
assign sum_wire[1] = a[1] ^ b[1] ^ c[0];
assign sum_wire[2] = a[2] ^ b[2] ^ c[1];
assign sum_wire[3] = a[3] ^ b[3] ^ c[2];
assign sum_wire[4] = a[4] ^ b[4] ^ c[3];
assign sum_wire[5] = a[5] ^ b[5] ^ c[4];
assign sum_wire[6] = a[6] ^ b[6] ^ c[5];
assign sum_wire[7] = a[7] ^ b[7] ^ c[6];

// Assign sum and cout
assign sum = sum_wire;
assign cout = g[7] | (p[7] & c[6]);

endmodule