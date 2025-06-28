module TopModule (
  input [4:1] x,
  output logic f
);

  // Implement the function f using if-else statements based on Karnaugh map patterns
  always_comb begin
    if (x == 4'b0000 || x == 4'b0010 || x == 4'b1100 || x == 4'b1101 || x == 4'b1111)
      f = 1'b1;
    else if (x == 4'b0001 || x == 4'b0011 || x == 4'b1110)
      f = 1'b0;
    else
      f = 1'b0; // Default case for any unspecified input
  end

endmodule