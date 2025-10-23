module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Split the 1024-bit input vector into 16 memory blocks of 64 bits each
wire [63:0] mem_block [15:0];
genvar i;
for (i = 0; i < 16; i++) begin
    assign mem_block[i] = in[(i * 64) +: 64];
end

// Split the 8-bit selector into block selector (4 bits) and address (4 bits)
wire [3:0] block_sel = sel[7:4];
wire [3:0] addr = sel[3:0];

// Use address decoding to select the correct memory block
wire [63:0] selected_block;
assign selected_block = mem_block[block_sel];

// Use indexing to select the correct 4-bit value from the chosen block
// with optimization to reduce unnecessary switching
assign out = selected_block[addr * 4 +: 4];

endmodule