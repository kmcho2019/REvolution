module TopModule(
    input [7:0] in,
    output parity
);

wire parity_lo; // Parity of the lower 4 bits
wire parity_hi; // Parity of the higher 4 bits

assign parity_lo = in[0] ^ in[1] ^ in[2] ^ in[3];
assign parity_hi = in[4] ^ in[5] ^ in[6] ^ in[7];

assign parity = parity_lo ^ parity_hi;

endmodule