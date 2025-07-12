module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Define the ROM for storing pre-computed population counts
reg [7:0] rom [0:65535];

// Initialize the ROM with pre-computed population counts
initial begin
    for (int i = 0; i < 65536; i++) begin
        reg [15:0] temp;
        temp = i;
        rom[i] = $countones(temp);
    end
end

// Divide the input into 16 blocks of 16 bits
wire [15:0] block [15:0];

// Assign the blocks
assign block[0] = in[15:0];
assign block[1] = in[31:16];
assign block[2] = in[47:32];
assign block[3] = in[63:48];
assign block[4] = in[79:64];
assign block[5] = in[95:80];
assign block[6] = in[111:96];
assign block[7] = in[127:112];
assign block[8] = in[143:128];
assign block[9] = in[159:144];
assign block[10] = in[175:160];
assign block[11] = in[191:176];
assign block[12] = in[207:192];
assign block[13] = in[223:208];
assign block[14] = in[239:224];
assign block[15] = {1'b0, in[254:240]};

// Population counts for each block
wire [7:0] block_count [15:0];

// Assign the population counts using the ROM
assign block_count[0] = rom[block[0]];
assign block_count[1] = rom[block[1]];
assign block_count[2] = rom[block[2]];
assign block_count[3] = rom[block[3]];
assign block_count[4] = rom[block[4]];
assign block_count[5] = rom[block[5]];
assign block_count[6] = rom[block[6]];
assign block_count[7] = rom[block[7]];
assign block_count[8] = rom[block[8]];
assign block_count[9] = rom[block[9]];
assign block_count[10] = rom[block[10]];
assign block_count[11] = rom[block[11]];
assign block_count[12] = rom[block[12]];
assign block_count[13] = rom[block[13]];
assign block_count[14] = rom[block[14]];
assign block_count[15] = rom[block[15]];

// Final population count using a tree-like adder structure
wire [7:0] count;

// Assign the final population count
assign count = block_count[0] + block_count[1] + block_count[2] + block_count[3] + block_count[4] + block_count[5] + block_count[6] + block_count[7] + 
               block_count[8] + block_count[9] + block_count[10] + block_count[11] + block_count[12] + block_count[13] + block_count[14] + block_count[15];

// Assign the output
assign out = count;

endmodule