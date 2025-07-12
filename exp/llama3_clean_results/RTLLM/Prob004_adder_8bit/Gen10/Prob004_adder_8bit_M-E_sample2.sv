module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Stage 1: Lower 4 bits (bits 0-3) using Carry-Lookahead Adder
wire [3:0] sum_stage1;
wire cout_stage1;

// Generate and propagate signals for Stage 1
wire [3:0] g_stage1, p_stage1;
assign g_stage1[0] = a[0] & b[0];
assign p_stage1[0] = a[0] | b[0];
assign g_stage1[1] = a[1] & b[1];
assign p_stage1[1] = a[1] | b[1];
assign g_stage1[2] = a[2] & b[2];
assign p_stage1[2] = a[2] | b[2];
assign g_stage1[3] = a[3] & b[3];
assign p_stage1[3] = a[3] | b[3];

// Carry signals for Stage 1 using lookahead logic
wire [3:0] c_stage1;
assign c_stage1[0] = g_stage1[0] | (p_stage1[0] & cin);
assign c_stage1[1] = g_stage1[1] | (p_stage1[1] & c_stage1[0]);
assign c_stage1[2] = g_stage1[2] | (p_stage1[2] & c_stage1[1]);
assign c_stage1[3] = g_stage1[3] | (p_stage1[3] & c_stage1[2]);

// Sum signals for Stage 1
assign sum_stage1[0] = a[0] ^ b[0] ^ cin;
assign sum_stage1[1] = a[1] ^ b[1] ^ c_stage1[0];
assign sum_stage1[2] = a[2] ^ b[2] ^ c_stage1[1];
assign sum_stage1[3] = a[3] ^ b[3] ^ c_stage1[2];

// Carry output for Stage 1
assign cout_stage1 = g_stage1[3] | (p_stage1[3] & c_stage1[2]);

// Stage 2: Upper 4 bits (bits 4-7) using combination of RCAs and CLAs
wire [3:0] sum_stage2;
wire cout_stage2;

// Generate and propagate signals for Stage 2
wire [3:0] g_stage2, p_stage2;
assign g_stage2[0] = a[4] & b[4];
assign p_stage2[0] = a[4] | b[4];
assign g_stage2[1] = a[5] & b[5];
assign p_stage2[1] = a[5] | b[5];
assign g_stage2[2] = a[6] & b[6];
assign p_stage2[2] = a[6] | b[6];
assign g_stage2[3] = a[7] & b[7];
assign p_stage2[3] = a[7] | b[7];

// Carry signals for Stage 2 using combination of RCAs and CLAs
wire [3:0] c_stage2;
assign c_stage2[0] = g_stage2[0] | (p_stage2[0] & cout_stage1);
assign c_stage2[1] = g_stage2[1] | (p_stage2[1] & c_stage2[0]);
assign c_stage2[2] = g_stage2[2] | (p_stage2[2] & c_stage2[1]);
assign c_stage2[3] = g_stage2[3] | (p_stage2[3] & c_stage2[2]);

// Sum signals for Stage 2
assign sum_stage2[0] = a[4] ^ b[4] ^ cout_stage1;
assign sum_stage2[1] = a[5] ^ b[5] ^ c_stage2[0];
assign sum_stage2[2] = a[6] ^ b[6] ^ c_stage2[1];
assign sum_stage2[3] = a[7] ^ b[7] ^ c_stage2[2];

// Carry output for Stage 2
assign cout_stage2 = g_stage2[3] | (p_stage2[3] & c_stage2[2]);

// Final sum and carry output
assign sum[3:0] = sum_stage1;
assign sum[7:4] = sum_stage2;
assign cout = cout_stage2;

endmodule