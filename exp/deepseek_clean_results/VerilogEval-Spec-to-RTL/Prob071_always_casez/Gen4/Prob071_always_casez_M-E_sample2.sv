module TopModule (
    input [7:0] in,
    output [2:0] pos
);

// Generate mask of bits to the right of first set bit
wire [7:0] mask = in & ~(in - 1);

// Logarithmic encoder for the mask
assign pos[2] = |mask[7:4];
assign pos[1] = |(mask[7:4] ? mask[7:6] : mask[3:2]);
assign pos[0] = (mask[7:4] ? (mask[7] ? mask[7] : mask[5]) :
                (mask[3] ? mask[3] : mask[1]));

endmodule