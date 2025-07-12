module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Define the pre-computed table for population count of 8-bit numbers
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

// Divide the input into 32 chunks of 8 bits
reg [7:0] chunk [31:0];

// Assign chunks directly
assign chunk[0]  = in[7:0];
assign chunk[1]  = in[15:8];
assign chunk[2]  = in[23:16];
assign chunk[3]  = in[31:24];
assign chunk[4]  = in[39:32];
assign chunk[5]  = in[47:40];
assign chunk[6]  = in[55:48];
assign chunk[7]  = in[63:56];
assign chunk[8]  = in[71:64];
assign chunk[9]  = in[79:72];
assign chunk[10] = in[87:80];
assign chunk[11] = in[95:88];
assign chunk[12] = in[103:96];
assign chunk[13] = in[111:104];
assign chunk[14] = in[119:112];
assign chunk[15] = in[127:120];
assign chunk[16] = in[135:128];
assign chunk[17] = in[143:136];
assign chunk[18] = in[151:144];
assign chunk[19] = in[159:152];
assign chunk[20] = in[167:160];
assign chunk[21] = in[175:168];
assign chunk[22] = in[183:176];
assign chunk[23] = in[191:184];
assign chunk[24] = in[199:192];
assign chunk[25] = in[207:200];
assign chunk[26] = in[215:208];
assign chunk[27] = in[223:216];
assign chunk[28] = in[231:224];
assign chunk[29] = in[239:232];
assign chunk[30] = in[247:240];
assign chunk[31] = {1'b0, in[254:248]};

// Calculate population count for each chunk using the pre-computed table
reg [3:0] chunk_count [31:0];
assign chunk_count[0]  = pop_count_table[chunk[0]];
assign chunk_count[1]  = pop_count_table[chunk[1]];
assign chunk_count[2]  = pop_count_table[chunk[2]];
assign chunk_count[3]  = pop_count_table[chunk[3]];
assign chunk_count[4]  = pop_count_table[chunk[4]];
assign chunk_count[5]  = pop_count_table[chunk[5]];
assign chunk_count[6]  = pop_count_table[chunk[6]];
assign chunk_count[7]  = pop_count_table[chunk[7]];
assign chunk_count[8]  = pop_count_table[chunk[8]];
assign chunk_count[9]  = pop_count_table[chunk[9]];
assign chunk_count[10] = pop_count_table[chunk[10]];
assign chunk_count[11] = pop_count_table[chunk[11]];
assign chunk_count[12] = pop_count_table[chunk[12]];
assign chunk_count[13] = pop_count_table[chunk[13]];
assign chunk_count[14] = pop_count_table[chunk[14]];
assign chunk_count[15] = pop_count_table[chunk[15]];
assign chunk_count[16] = pop_count_table[chunk[16]];
assign chunk_count[17] = pop_count_table[chunk[17]];
assign chunk_count[18] = pop_count_table[chunk[18]];
assign chunk_count[19] = pop_count_table[chunk[19]];
assign chunk_count[20] = pop_count_table[chunk[20]];
assign chunk_count[21] = pop_count_table[chunk[21]];
assign chunk_count[22] = pop_count_table[chunk[22]];
assign chunk_count[23] = pop_count_table[chunk[23]];
assign chunk_count[24] = pop_count_table[chunk[24]];
assign chunk_count[25] = pop_count_table[chunk[25]];
assign chunk_count[26] = pop_count_table[chunk[26]];
assign chunk_count[27] = pop_count_table[chunk[27]];
assign chunk_count[28] = pop_count_table[chunk[28]];
assign chunk_count[29] = pop_count_table[chunk[29]];
assign chunk_count[30] = pop_count_table[chunk[30]];
assign chunk_count[31] = pop_count_table[chunk[31]];

// Pipelined architecture for the final summation
reg [7:0] sum;
reg [7:0] sum1;
reg [7:0] sum2;

assign sum1 = chunk_count[0]  + chunk_count[1]  + chunk_count[2]  + chunk_count[3]  + 
              chunk_count[4]  + chunk_count[5]  + chunk_count[6]  + chunk_count[7]  + 
              chunk_count[8]  + chunk_count[9]  + chunk_count[10] + chunk_count[11] + 
              chunk_count[12] + chunk_count[13] + chunk_count[14] + chunk_count[15];
assign sum2 = chunk_count[16] + chunk_count[17] + chunk_count[18] + chunk_count[19] + 
              chunk_count[20] + chunk_count[21] + chunk_count[22] + chunk_count[23] + 
              chunk_count[24] + chunk_count[25] + chunk_count[26] + chunk_count[27] + 
              chunk_count[28] + chunk_count[29] + chunk_count[30] + chunk_count[31];
assign sum  = sum1 + sum2;

assign out = sum;

endmodule