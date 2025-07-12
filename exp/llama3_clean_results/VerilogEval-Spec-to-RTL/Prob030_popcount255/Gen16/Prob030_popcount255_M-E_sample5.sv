module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];

// Assign the segments
genvar i;
for (i = 0; i < 32; i++) begin
    if (i == 31) begin
        assign segment[i] = {1'b0, in[254:248]};
    end else begin
        assign segment[i] = in[(i*8)+7:i*8];
    end
end

// Population counts for each segment
reg [7:0] segment_count [31:0];

// Shift registers for each segment
reg [7:0] shift_reg [31:0];

// Initialize the shift registers and counters
initial begin
    for (int i = 0; i < 32; i++) begin
        shift_reg[i] = 0;
        segment_count[i] = 0;
    end
end

// Count the population for each segment
always @(*) begin
    for (int i = 0; i < 32; i++) begin
        shift_reg[i] = segment[i];
        segment_count[i] = 0;
        for (int j = 0; j < 8; j++) begin
            if (shift_reg[i][j] == 1'b1) begin
                segment_count[i] = segment_count[i] + 1;
            end
        end
    end
end

// Hierarchical tree-like structure of adders
wire [7:0] level1_sum [15:0];
assign level1_sum[0] = segment_count[0] + segment_count[1];
assign level1_sum[1] = segment_count[2] + segment_count[3];
assign level1_sum[2] = segment_count[4] + segment_count[5];
assign level1_sum[3] = segment_count[6] + segment_count[7];
assign level1_sum[4] = segment_count[8] + segment_count[9];
assign level1_sum[5] = segment_count[10] + segment_count[11];
assign level1_sum[6] = segment_count[12] + segment_count[13];
assign level1_sum[7] = segment_count[14] + segment_count[15];
assign level1_sum[8] = segment_count[16] + segment_count[17];
assign level1_sum[9] = segment_count[18] + segment_count[19];
assign level1_sum[10] = segment_count[20] + segment_count[21];
assign level1_sum[11] = segment_count[22] + segment_count[23];
assign level1_sum[12] = segment_count[24] + segment_count[25];
assign level1_sum[13] = segment_count[26] + segment_count[27];
assign level1_sum[14] = segment_count[28] + segment_count[29];
assign level1_sum[15] = segment_count[30] + segment_count[31];

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