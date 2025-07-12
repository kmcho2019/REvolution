module TopModule (
    input [3:0] in,
    output [1:0] pos
);

assign pos = (in == 4'b0000) ? 2'b00 :  // All zeros case
             (in[0])         ? 2'b00 :  // Bit 0 is 1
             (in[1])         ? 2'b01 :  // Bit 1 is 1
             (in[2])         ? 2'b10 :  // Bit 2 is 1
                               2'b11;   // Bit 3 is 1 (default case)

endmodule