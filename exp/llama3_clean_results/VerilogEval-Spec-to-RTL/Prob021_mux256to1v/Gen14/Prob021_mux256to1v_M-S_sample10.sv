module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the block offset and group offset within the block
wire [9:0] offset = (sel[7:4] * 64) + (sel[3:0] * 4);

// Use the calculated offset to directly extract the output from the input vector
assign out = in[offset +: 4];

endmodule