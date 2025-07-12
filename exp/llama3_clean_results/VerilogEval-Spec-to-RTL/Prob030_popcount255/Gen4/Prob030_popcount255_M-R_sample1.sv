module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Pre-computed table for population count of 8-bit numbers
reg [3:0] pop_count_table [255:0];

// Initialize the pre-computed table
always @(*) begin
    for (int i = 0; i < 256; i++) begin
        pop_count_table[i] = 4'd0;
        for (int j = 0; j < 8; j++) begin
            if (i[j]) begin
                pop_count_table[i] = pop_count_table[i] + 1;
            end
        end
    end
end

// Divide the input into chunks and calculate population count for each chunk
reg [3:0] chunk_count [31:0];
assign chunk_count[0]  = pop_count_table[in[7:0]];
assign chunk_count[1]  = pop_count_table[in[15:8]];
assign chunk_count[2]  = pop_count_table[in[23:16]];
assign chunk_count[3]  = pop_count_table[in[31:24]];
assign chunk_count[4]  = pop_count_table[in[39:32]];
assign chunk_count[5]  = pop_count_table[in[47:40]];
assign chunk_count[6]  = pop_count_table[in[55:48]];
assign chunk_count[7]  = pop_count_table[in[63:56]];
assign chunk_count[8]  = pop_count_table[in[71:64]];
assign chunk_count[9]  = pop_count_table[in[79:72]];
assign chunk_count[10] = pop_count_table[in[87:80]];
assign chunk_count[11] = pop_count_table[in[95:88]];
assign chunk_count[12] = pop_count_table[in[103:96]];
assign chunk_count[13] = pop_count_table[in[111:104]];
assign chunk_count[14] = pop_count_table[in[119:112]];
assign chunk_count[15] = pop_count_table[in[127:120]];
assign chunk_count[16] = pop_count_table[in[135:128]];
assign chunk_count[17] = pop_count_table[in[143:136]];
assign chunk_count[18] = pop_count_table[in[151:144]];
assign chunk_count[19] = pop_count_table[in[159:152]];
assign chunk_count[20] = pop_count_table[in[167:160]];
assign chunk_count[21] = pop_count_table[in[175:168]];
assign chunk_count[22] = pop_count_table[in[183:176]];
assign chunk_count[23] = pop_count_table[in[191:184]];
assign chunk_count[24] = pop_count_table[in[199:192]];
assign chunk_count[25] = pop_count_table[in[207:200]];
assign chunk_count[26] = pop_count_table[in[215:208]];
assign chunk_count[27] = pop_count_table[in[223:216]];
assign chunk_count[28] = pop_count_table[in[231:224]];
assign chunk_count[29] = pop_count_table[in[239:232]];
assign chunk_count[30] = pop_count_table[in[247:240]];
assign chunk_count[31] = pop_count_table[{1'b0, in[254:248]}];

// Sum up the population counts for the final output
reg [7:0] sum;
always @(*) begin
    sum = 8'd0;
    for (int i = 0; i < 32; i++) begin
        sum = sum + chunk_count[i];
    end
end

assign out = sum;

endmodule