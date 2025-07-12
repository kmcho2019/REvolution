module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Split the 8-bit selector into block selector (4 bits) and address (4 bits)
wire [3:0] block_sel = sel[7:4];
wire [3:0] addr = sel[3:0];

// Split the 1024-bit input vector into 256 blocks of 4 bits each
wire [3:0] mem_block [255:0];
genvar i;
for (i = 0; i < 256; i++) begin
    assign mem_block[i] = in[(i * 4) +: 4];
end

// Use address decoding to select the correct memory block
wire [3:0] selected_block;
assign selected_block = mem_block[(block_sel * 16) + addr];

// Use indexing to select the correct 4-bit value from the chosen block
assign out = selected_block;

endmodule