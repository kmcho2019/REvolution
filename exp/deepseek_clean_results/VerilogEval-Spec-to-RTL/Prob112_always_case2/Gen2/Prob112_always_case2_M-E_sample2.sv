module TopModule (
    input [3:0] in,
    output [1:0] pos
);

wire [3:0] masked = in & ((~in) + 1);  // Isolate rightmost 1 bit
assign pos = (masked == 4'b0001) ? 2'b00 :
             (masked == 4'b0010) ? 2'b01 :
             (masked == 4'b0100) ? 2'b10 :
             (masked == 4'b1000) ? 2'b11 :
             2'b00;  // Default case (all zeros)

endmodule