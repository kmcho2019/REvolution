module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Split the 8-bit selector into block selector (4 bits) and address (4 bits)
wire [3:0] block_sel = sel[7:4];
wire [3:0] addr = sel[3:0];

// First stage: Select one of 16 groups of 64 bits from the input vector
wire [63:0] group_out [15:0];
genvar i;
for (i = 0; i < 16; i++) begin
    assign group_out[i] = in[(i * 64) +: 64];
end

// Second stage: Select the correct 4-bit output from the chosen group
assign out = group_out[block_sel][(addr * 4) +: 4];

endmodule