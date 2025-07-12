module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Directly calculate the starting index for the group selection
wire [5:0] group_index = sel[7:4];

// Calculate the offset within the group based on the lower 4 bits of sel
wire [1:0] group_offset = sel[3:2];

// Final offset calculation to select the correct 4-bit word
wire [9:0] final_offset = {group_index, group_offset};

// Select the 4-bit output directly from the input vector
assign out = in[{final_offset, 2'b00} +: 4];

endmodule