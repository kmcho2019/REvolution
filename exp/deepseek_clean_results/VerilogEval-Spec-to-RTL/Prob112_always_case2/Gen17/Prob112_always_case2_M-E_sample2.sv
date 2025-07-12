module TopModule (
    input [3:0] in,
    output [1:0] pos
);

assign pos = (in[3]) ? 2'b11 :       // Highest priority (bit 3)
             (in[2]) ? 2'b10 :       // Next priority (bit 2)
             (in[1]) ? 2'b01 :       // Then bit 1
             (in[0]) ? 2'b00 :       // Finally bit 0
                       2'b00;       // All zeros case

endmodule