module TopModule (
  input [5:0] y,
  input w,
  output reg Y1,
  output reg Y3
);

  always @* begin
    Y1 = (y[1] == 1 && (y == 6'b000010 || y == 6'b100000)) ? w : 1'b0; // Transitions to B or F
    Y3 = (y[3] == 1 && (y == 6'b000100 || y == 6'b010000)) ? w : 1'b0; // Transitions to C or E
  end

endmodule