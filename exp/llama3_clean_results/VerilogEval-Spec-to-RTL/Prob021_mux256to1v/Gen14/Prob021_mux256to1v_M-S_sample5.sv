module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the index of the 4-bit value within the 1024-bit input vector
wire [11:0] index = {sel, 2'b00};

// Assign the 4-bit value at the calculated index to the output
assign out = in[(index * 4) +: 4];

endmodule