module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  assign Y1 = (y == 6'b000001) ? w : (y == 6'b000010) ? 1'b0 : (y == 6'b000100) ? 1'b0 : 
              (y == 6'b001000) ? 1'b0 : (y == 6'b010000) ? 1'b0 : (y == 6'b100000) ? w : 1'b0;
  
  assign Y3 = (y == 6'b000001) ? 1'b0 : (y == 6'b000010) ? 1'b0 : (y == 6'b000100) ? w : 
              (y == 6'b001000) ? 1'b0 : (y == 6'b010000) ? w : (y == 6'b100000) ? w : 1'b0;

endmodule