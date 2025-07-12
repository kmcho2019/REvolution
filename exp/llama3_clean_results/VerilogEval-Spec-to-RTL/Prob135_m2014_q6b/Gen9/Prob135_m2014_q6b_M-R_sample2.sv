module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

assign Y1 = (y == 3'b000) ? w :
             (y == 3'b001) ? 0 :
             (y == 3'b010) ? 1 :
             (y == 3'b011) ? (w == 0) ? 0 : 1 :
             (y == 3'b100) ? 1 :
             (y == 3'b101) ? (w == 0) ? 0 : 1 :
             1'b0;

endmodule