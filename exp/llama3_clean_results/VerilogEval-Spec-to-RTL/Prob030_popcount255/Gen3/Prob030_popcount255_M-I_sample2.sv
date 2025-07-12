module TopModule (
    input  [254:0] in,
    output [7:0] out
);

wire [7:0] count;

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];

// Population count for each segment
wire [3:0] segment_count [31:0];

// Compressor tree to sum up the counts from each segment
wire [7:0] tree_count;

assign segment[0]  = in[7:0];
assign segment[1]  = in[15:8];
assign segment[2]  = in[23:16];
assign segment[3]  = in[31:24];
assign segment[4]  = in[39:32];
assign segment[5]  = in[47:40];
assign segment[6]  = in[55:48];
assign segment[7]  = in[63:56];
assign segment[8]  = in[71:64];
assign segment[9]  = in[79:72];
assign segment[10] = in[87:80];
assign segment[11] = in[95:88];
assign segment[12] = in[103:96];
assign segment[13] = in[111:104];
assign segment[14] = in[119:112];
assign segment[15] = in[127:120];
assign segment[16] = in[135:128];
assign segment[17] = in[143:136];
assign segment[18] = in[151:144];
assign segment[19] = in[159:152];
assign segment[20] = in[167:160];
assign segment[21] = in[175:168];
assign segment[22] = in[183:176];
assign segment[23] = in[191:184];
assign segment[24] = in[199:192];
assign segment[25] = in[207:200];
assign segment[26] = in[215:208];
assign segment[27] = in[223:216];
assign segment[28] = in[231:224];
assign segment[29] = in[239:232];
assign segment[30] = in[247:240];
assign segment[31] = {1'b0, in[254:248]};

// Population count for each segment
genvar i;
generate
    for (i = 0; i < 32; i++) begin
        always @(*) begin
            segment_count[i] = 4'd0;
            for (int j = 0; j < 8; j++) begin
                if (segment[i][j]) begin
                    segment_count[i] = segment_count[i] + 1;
                end
            end
        end
    end
endgenerate

// Compressor tree to sum up the counts from each segment
always @(*) begin
    tree_count = 8'd0;
    for (int i = 0; i < 32; i++) begin
        tree_count = tree_count + segment_count[i];
    end
end

assign count = tree_count;
assign out = count;

endmodule