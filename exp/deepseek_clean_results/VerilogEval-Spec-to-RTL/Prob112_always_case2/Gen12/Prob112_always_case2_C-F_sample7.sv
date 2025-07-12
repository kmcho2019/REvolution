module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always_comb begin
    case (1'b1)
        (in == 4'b0000): pos = 2'b00;  // All zeros case first for power efficiency
        (in[0]):        pos = 2'b00;   // Bit 0 set
        (in[1]):        pos = 2'b01;   // Bit 1 set
        (in[2]):        pos = 2'b10;   // Bit 2 set
        (in[3]):        pos = 2'b11;   // Bit 3 set
        default:        pos = 2'b00;   // Should never occur
    endcase
end

endmodule