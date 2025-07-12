module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Generate a mask with a single '1' bit at the position corresponding to the selected chunk
wire [255:0] mask;
assign mask = (1 << sel);

// Perform a bitwise AND operation with the input vector to select the desired chunk
wire [1023:0] masked_in;
assign masked_in = in & (mask << 3);

// Select the desired four-bit chunk
assign out = masked_in[3:0];

endmodule