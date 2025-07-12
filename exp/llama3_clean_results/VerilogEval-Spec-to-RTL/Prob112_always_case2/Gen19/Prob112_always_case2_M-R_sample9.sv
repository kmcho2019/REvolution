module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

assign pos = (in[3]) ? 2'b11 : // Most significant bit set
             (in[2]) ? 2'b10 : // Second bit set
             (in[1]) ? 2'b01 : // Third bit set
             (in[0]) ? 2'b00 : // Least significant bit set
             2'b00;          // No bits set, default to 0

endmodule