module TopModule(
    input [7:0] in,
    output parity
);

wire parity_lo; // Parity of the lower 4 bits
wire parity_hi; // Parity of the higher 4 bits

assign parity_lo = ^in[3:0]; // Use XOR reduction operator on lower 4 bits
assign parity_hi = ^in[7:4]; // Use XOR reduction operator on higher 4 bits

assign parity = parity_lo ^ parity_hi; // Combine the two parities

endmodule