module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the index of the selected 4-bit block
wire [9:0] index = {sel[7:4], sel[3:0]};

// Select the correct 4-bit block based on the index
assign out = in[index*4 +: 4];

endmodule