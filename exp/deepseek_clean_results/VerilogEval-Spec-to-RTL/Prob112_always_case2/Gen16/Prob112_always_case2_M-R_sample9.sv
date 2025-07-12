module TopModule (
    input [3:0] in,
    output [1:0] pos
);

assign pos = (in == 4'b0000) ? 2'b00 :  // All zero case
             (in[3]) ? 2'b11 :           // Bit 3 is highest priority
             (in[2]) ? 2'b10 :           // Then bit 2
             (in[1]) ? 2'b01 :           // Then bit 1
             2'b00;                      // Default to bit 0 (only if in[0] is set)

endmodule