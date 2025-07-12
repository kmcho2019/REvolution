module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the offset within the 1024-bit input vector
wire [9:0] offset;
assign offset = {sel[7:4], sel[3:0]} * 4;

// Use the calculated offset to select the desired 4-bit block
assign out = in[(offset + 3):offset];

endmodule