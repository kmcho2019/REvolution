module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Split the 1024-bit input vector into 16 blocks of 64 bits each
wire [63:0] block [15:0];
genvar i;
for (i = 0; i < 16; i++) begin
    assign block[i] = in[(i * 64) +: 64];
end

// Use the upper 4 bits of the selector to select one of the 16 blocks
wire [63:0] selected_block;
assign selected_block = block[sel[7:4]];

// Split the selected block into 16 blocks of 4 bits each
wire [3:0] sub_block [15:0];
for (i = 0; i < 16; i++) begin
    assign sub_block[i] = selected_block[(i * 4) +: 4];
end

// Use the lower 4 bits of the selector to select one of the 16 sub-blocks
assign out = sub_block[sel[3:0]];

endmodule