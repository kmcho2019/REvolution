module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Define the LUT for population count of 8-bit chunks
wire [7:0] lut_out [255:0];

// Initialize the LUT
initial begin
    for (int i = 0; i < 256; i++) begin
        lut_out[i] = $countones(i);
    end
end

// Divide the input into 32 chunks of 8 bits
wire [7:0] chunk [31:0];

// Assign the chunks
genvar i;
for (i = 0; i < 32; i++) begin
    if (i == 31) begin
        assign chunk[i] = {1'b0, in[254:248]};
    end else begin
        assign chunk[i] = in[(i*8)+7:i*8];
    end
end

// Population counts for each chunk using LUT
wire [7:0] chunk_count [31:0];

// Assign the population counts
for (genvar i = 0; i < 32; i++) begin
    assign chunk_count[i] = lut_out[chunk[i]];
end

// Hierarchical adder tree
wire [7:0] level1_count [15:0];
assign level1_count[0]  = chunk_count[0]  + chunk_count[1];
assign level1_count[1]  = chunk_count[2]  + chunk_count[3];
assign level1_count[2]  = chunk_count[4]  + chunk_count[5];
assign level1_count[3]  = chunk_count[6]  + chunk_count[7];
assign level1_count[4]  = chunk_count[8]  + chunk_count[9];
assign level1_count[5]  = chunk_count[10] + chunk_count[11];
assign level1_count[6]  = chunk_count[12] + chunk_count[13];
assign level1_count[7]  = chunk_count[14] + chunk_count[15];
assign level1_count[8]  = chunk_count[16] + chunk_count[17];
assign level1_count[9]  = chunk_count[18] + chunk_count[19];
assign level1_count[10] = chunk_count[20] + chunk_count[21];
assign level1_count[11] = chunk_count[22] + chunk_count[23];
assign level1_count[12] = chunk_count[24] + chunk_count[25];
assign level1_count[13] = chunk_count[26] + chunk_count[27];
assign level1_count[14] = chunk_count[28] + chunk_count[29];
assign level1_count[15] = chunk_count[30] + chunk_count[31];

wire [7:0] level2_count [7:0];
assign level2_count[0] = level1_count[0] + level1_count[1];
assign level2_count[1] = level1_count[2] + level1_count[3];
assign level2_count[2] = level1_count[4] + level1_count[5];
assign level2_count[3] = level1_count[6] + level1_count[7];
assign level2_count[4] = level1_count[8] + level1_count[9];
assign level2_count[5] = level1_count[10] + level1_count[11];
assign level2_count[6] = level1_count[12] + level1_count[13];
assign level2_count[7] = level1_count[14] + level1_count[15];

wire [7:0] level3_count [3:0];
assign level3_count[0] = level2_count[0] + level2_count[1];
assign level3_count[1] = level2_count[2] + level2_count[3];
assign level3_count[2] = level2_count[4] + level2_count[5];
assign level3_count[3] = level2_count[6] + level2_count[7];

wire [7:0] level4_count [1:0];
assign level4_count[0] = level3_count[0] + level3_count[1];
assign level4_count[1] = level3_count[2] + level3_count[3];

wire [7:0] count;
assign count = level4_count[0] + level4_count[1];

// Assign the output
assign out = count;

endmodule