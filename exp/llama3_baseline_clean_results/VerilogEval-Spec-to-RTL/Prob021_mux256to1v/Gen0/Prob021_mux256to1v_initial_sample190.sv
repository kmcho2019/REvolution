module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the starting index based on the select signal
wire [9:0] start_idx = {2'b0, sel} * 4;

// Use the calculated index to extract the 4-bit wide data
assign out = in[start_idx +: 4];

endmodule