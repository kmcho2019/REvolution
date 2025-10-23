module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the offset within the input vector based on the selector
wire [9:0] offset = {sel[7:4], sel[3:0]};

// Use the calculated offset to select the correct 4-bit value
assign out = in[(offset * 4) +: 4];

endmodule