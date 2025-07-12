module TopModule (
    input [7:0] in,
    output parity
);
    // 256-bit LUT containing precomputed even parity for all 8-bit values
    // Each bit represents parity for its index (e.g., bit 0 = parity of 8'b00000000)
    reg [255:0] parity_lut = 256'h699696699669699669699669699696699669699669699696966996699669699696;

    assign parity = parity_lut[in];
endmodule