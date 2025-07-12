module TopModule (
    input [3:0] in,
    output [1:0] pos
);

assign pos = in[0] ? 2'b00 :    // Bit 0 has highest priority
             in[1] ? 2'b01 :    // Then bit 1
             in[2] ? 2'b10 :    // Then bit 2
             in[3] ? 2'b11 :    // Then bit 3
             2'b00;             // Default case (all zeros)

endmodule