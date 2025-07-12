module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Chunking Stage
wire [14:0] chunk [16:0];

// Assign chunks
assign chunk[0] = in[14:0];
assign chunk[1] = in[29:15];
assign chunk[2] = in[44:30];
assign chunk[3] = in[59:45];
assign chunk[4] = in[74:60];
assign chunk[5] = in[89:75];
assign chunk[6] = in[104:90];
assign chunk[7] = in[119:105];
assign chunk[8] = in[134:120];
assign chunk[9] = in[149:135];
assign chunk[10] = in[164:150];
assign chunk[11] = in[179:165];
assign chunk[12] = in[194:180];
assign chunk[13] = in[209:195];
assign chunk[14] = in[224:210];
assign chunk[15] = in[239:225];
assign chunk[16] = {8'b0, in[254:241]};

// Parallel Processing Stage
wire [3:0] chunk_count [16:0];

// Population count for each chunk
genvar i;
generate
    for (i = 0; i < 17; i++) begin
        always @(*) begin
            chunk_count[i] = 4'b0;
            for (int j = 0; j < 15; j++) begin
                if (chunk[i][j]) begin
                    chunk_count[i] = chunk_count[i] + 1;
                end
            end
        end
    end
endgenerate

// Hierarchical Combination Stage
wire [7:0] level1_count [8:0];
wire [7:0] level2_count [3:0];
wire [7:0] level3_count [1:0];
wire [7:0] final_count;

// Level 1 combination
assign level1_count[0] = chunk_count[0] + chunk_count[1];
assign level1_count[1] = chunk_count[2] + chunk_count[3];
assign level1_count[2] = chunk_count[4] + chunk_count[5];
assign level1_count[3] = chunk_count[6] + chunk_count[7];
assign level1_count[4] = chunk_count[8] + chunk_count[9];
assign level1_count[5] = chunk_count[10] + chunk_count[11];
assign level1_count[6] = chunk_count[12] + chunk_count[13];
assign level1_count[7] = chunk_count[14] + chunk_count[15];
assign level1_count[8] = chunk_count[16];

// Level 2 combination
assign level2_count[0] = level1_count[0] + level1_count[1];
assign level2_count[1] = level1_count[2] + level1_count[3];
assign level2_count[2] = level1_count[4] + level1_count[5];
assign level2_count[3] = level1_count[6] + level1_count[7];

// Level 3 combination
assign level3_count[0] = level2_count[0] + level2_count[1];
assign level3_count[1] = level2_count[2] + level2_count[3];

// Final combination
assign final_count = level3_count[0] + level3_count[1];

// Assign output
assign out = final_count;

endmodule