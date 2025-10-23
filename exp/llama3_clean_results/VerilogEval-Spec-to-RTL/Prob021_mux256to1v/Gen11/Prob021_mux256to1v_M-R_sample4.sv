module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Split the 8-bit selector into block selector (4 bits) and address (4 bits)
wire [3:0] block_sel = sel[7:4];
wire [3:0] addr = sel[3:0];

// Calculate the offset of the desired 4-bit value within the input vector
wire [9:0] offset = {block_sel, addr} << 2;

// Use bit manipulation to select the correct 4-bit value from the input vector
assign out = in[(offset + 3) : offset];

endmodule