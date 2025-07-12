module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Split the 8-bit selector into block selector (4 bits) and address (4 bits)
wire [3:0] block_sel = sel[7:4];
wire [3:0] addr = sel[3:0];

// Calculate the start index of the selected block
wire [9:0] block_start = {block_sel, 4'd0} << 2;

// Calculate the offset within the block to select the 4-bit output
wire [9:0] offset = addr << 2;

// Use arithmetic operations to select the correct 4-bit value from the input vector
assign out = in[{block_start, offset} +: 4];

endmodule