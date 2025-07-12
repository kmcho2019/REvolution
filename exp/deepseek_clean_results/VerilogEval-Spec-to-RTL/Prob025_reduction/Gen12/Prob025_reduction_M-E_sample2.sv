module TopModule (
    input [7:0] in,
    output parity
);
    // 256-bit LUT containing precomputed even parity for all 8-bit values
    reg [255:0] parity_lut = 256'h6996_9669_9669_6996_9669_6996_6996_9669_9669_6996_6996_9669_6996_9669_9669_6996;

    assign parity = parity_lut[in];
endmodule