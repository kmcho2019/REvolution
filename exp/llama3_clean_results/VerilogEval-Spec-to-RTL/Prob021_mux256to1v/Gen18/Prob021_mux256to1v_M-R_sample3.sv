module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the offset of the desired 4-bit group
wire [9:0] offset = {sel[7:4], sel[3:0]} * 4;

// Extract the desired 4-bit output
assign out = in[(offset + 3) : offset];

endmodule