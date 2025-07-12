module TopModule (
    input [3:0] in,
    output [1:0] pos
);

wire [3:0] mask = in & -in;  // Isolate rightmost 1-bit

assign pos = (mask == 4'b0000) ? 2'b00 :  // All zeros case
             (mask == 4'b0001) ? 2'b00 :
             (mask == 4'b0010) ? 2'b01 :
             (mask == 4'b0100) ? 2'b10 :
                                2'b11;    // mask == 4'b1000 case

endmodule