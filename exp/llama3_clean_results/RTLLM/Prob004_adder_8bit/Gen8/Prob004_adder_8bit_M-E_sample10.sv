module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for the pipeline stages
wire [7:0] stage1_sum;
wire [7:0] stage2_sum;
wire [7:0] stage3_sum;
wire [7:0] stage4_sum;
wire [7:0] stage5_sum;
wire [7:0] stage6_sum;
wire [7:0] stage7_sum;
wire [7:0] stage8_sum;
wire stage1_cout, stage2_cout, stage3_cout, stage4_cout, stage5_cout, stage6_cout, stage7_cout, stage8_cout;

// Stage 1: Bit 0 adder
assign stage1_sum[0] = a[0] ^ b[0] ^ cin;
assign stage1_cout = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

// Stage 2: Bit 1 adder
assign stage2_sum[0] = a[1] ^ b[1] ^ stage1_cout;
assign stage2_cout = (a[1] & b[1]) | (a[1] & stage1_cout) | (b[1] & stage1_cout);

// Stage 3: Bit 2 adder
assign stage3_sum[0] = a[2] ^ b[2] ^ stage2_cout;
assign stage3_cout = (a[2] & b[2]) | (a[2] & stage2_cout) | (b[2] & stage2_cout);

// Stage 4: Bit 3 adder
assign stage4_sum[0] = a[3] ^ b[3] ^ stage3_cout;
assign stage4_cout = (a[3] & b[3]) | (a[3] & stage3_cout) | (b[3] & stage3_cout);

// Stage 5: Bit 4 adder
assign stage5_sum[0] = a[4] ^ b[4] ^ stage4_cout;
assign stage5_cout = (a[4] & b[4]) | (a[4] & stage4_cout) | (b[4] & stage4_cout);

// Stage 6: Bit 5 adder
assign stage6_sum[0] = a[5] ^ b[5] ^ stage5_cout;
assign stage6_cout = (a[5] & b[5]) | (a[5] & stage5_cout) | (b[5] & stage5_cout);

// Stage 7: Bit 6 adder
assign stage7_sum[0] = a[6] ^ b[6] ^ stage6_cout;
assign stage7_cout = (a[6] & b[6]) | (a[6] & stage6_cout) | (b[6] & stage6_cout);

// Stage 8: Bit 7 adder
assign stage8_sum[0] = a[7] ^ b[7] ^ stage7_cout;
assign stage8_cout = (a[7] & b[7]) | (a[7] & stage7_cout) | (b[7] & stage7_cout);

// Combine the sums and propagate the carry
assign sum[0] = stage1_sum[0];
assign sum[1] = stage2_sum[0];
assign sum[2] = stage3_sum[0];
assign sum[3] = stage4_sum[0];
assign sum[4] = stage5_sum[0];
assign sum[5] = stage6_sum[0];
assign sum[6] = stage7_sum[0];
assign sum[7] = stage8_sum[0];
assign cout = stage8_cout;

endmodule