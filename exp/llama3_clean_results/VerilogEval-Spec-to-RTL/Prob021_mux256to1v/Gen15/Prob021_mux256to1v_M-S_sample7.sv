module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the offset for the desired 4-bit output
wire [9:0] offset = {sel[7:2], 2'b00}; // Calculate the group offset
wire [1:0] low_bits = sel[1:0]; // Get the low 2 bits for position within the group

// Select the desired 4-bit output
assign out = in[(offset * 4) + low_bits * 4 +: 4];

endmodule