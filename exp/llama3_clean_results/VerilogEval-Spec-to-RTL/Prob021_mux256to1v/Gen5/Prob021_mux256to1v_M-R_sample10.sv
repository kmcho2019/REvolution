module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the offset into the 1024-bit input vector
wire [9:0] offset = (sel * 4);

// Extract the 4-bit output from the calculated offset
assign out = in[(offset + 3) : offset];

endmodule