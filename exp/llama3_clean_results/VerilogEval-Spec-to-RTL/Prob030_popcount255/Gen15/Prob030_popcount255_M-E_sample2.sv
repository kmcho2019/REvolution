module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Define the lookup table for population count
reg [7:0] lut [1:0];
always @(*) begin
    lut[0] = 8'd0;
    lut[1] = 8'd1;
end

// Calculate the population count for each bit
wire [7:0] pc [254:0];
genvar i;
for (i = 0; i < 255; i++) begin
    assign pc[i] = lut[in[i]];
end

// Define the parallel prefix adder
wire [7:0] sum [254:0];
assign sum[0] = pc[0];
for (genvar i = 1; i < 255; i++) begin
    assign sum[i] = sum[i-1] + pc[i];
end

// Define the hierarchical parallel prefix adder
wire [7:0] group_sum [31:0];
for (genvar i = 0; i < 31; i++) begin
    assign group_sum[i] = sum[(i+1)*8-1];
end
wire [7:0] level1_sum [15:0];
assign level1_sum[0] = group_sum[0] + group_sum[1];
assign level1_sum[1] = group_sum[2] + group_sum[3];
assign level1_sum[2] = group_sum[4] + group_sum[5];
assign level1_sum[3] = group_sum[6] + group_sum[7];
assign level1_sum[4] = group_sum[8] + group_sum[9];
assign level1_sum[5] = group_sum[10] + group_sum[11];
assign level1_sum[6] = group_sum[12] + group_sum[13];
assign level1_sum[7] = group_sum[14] + group_sum[15];
assign level1_sum[8] = group_sum[16] + group_sum[17];
assign level1_sum[9] = group_sum[18] + group_sum[19];
assign level1_sum[10] = group_sum[20] + group_sum[21];
assign level1_sum[11] = group_sum[22] + group_sum[23];
assign level1_sum[12] = group_sum[24] + group_sum[25];
assign level1_sum[13] = group_sum[26] + group_sum[27];
assign level1_sum[14] = group_sum[28] + group_sum[29];
assign level1_sum[15] = group_sum[30] + group_sum[31];

wire [7:0] level2_sum [7:0];
assign level2_sum[0] = level1_sum[0] + level1_sum[1];
assign level2_sum[1] = level1_sum[2] + level1_sum[3];
assign level2_sum[2] = level1_sum[4] + level1_sum[5];
assign level2_sum[3] = level1_sum[6] + level1_sum[7];
assign level2_sum[4] = level1_sum[8] + level1_sum[9];
assign level2_sum[5] = level1_sum[10] + level1_sum[11];
assign level2_sum[6] = level1_sum[12] + level1_sum[13];
assign level2_sum[7] = level1_sum[14] + level1_sum[15];

wire [7:0] level3_sum [3:0];
assign level3_sum[0] = level2_sum[0] + level2_sum[1];
assign level3_sum[1] = level2_sum[2] + level2_sum[3];
assign level3_sum[2] = level2_sum[4] + level2_sum[5];
assign level3_sum[3] = level2_sum[6] + level2_sum[7];

wire [7:0] level4_sum [1:0];
assign level4_sum[0] = level3_sum[0] + level3_sum[1];
assign level4_sum[1] = level3_sum[2] + level3_sum[3];

wire [7:0] count;
assign count = level4_sum[0] + level4_sum[1];

// Assign the output
assign out = count;

endmodule