module TopModule (
  input [3:0] x,
  output reg f
);

  // Implement the function f using simplified Boolean expressions
  always_comb begin
    f = (x == 4'b0000) | (x == 4'b0010) | (x == 4'b1100) | (x == 4'b1101) | (x == 4'b1111);
  end

endmodule