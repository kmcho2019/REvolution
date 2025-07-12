module TopModule(
    input  [3:0] x,
    output       f
);

    always @(*) case ({x[2], x[3]})
        2'b00: f = (~x[0] & ~x[1]) | (x[0] & ~x[1]);  // x[2]x[3] = 00
        2'b01: f = 1'b0;                           // x[2]x[3] = 01
        2'b11: f = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & x[1]);  // x[2]x[3] = 11
        2'b10: f = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1]);  // x[2]x[3] = 10
        default: f = 1'b0;                         // Default case (should not occur)
    endcase

endmodule