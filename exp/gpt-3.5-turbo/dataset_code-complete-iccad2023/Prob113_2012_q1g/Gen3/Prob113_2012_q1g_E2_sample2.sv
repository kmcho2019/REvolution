module TopModule (
  input [4:1] x,
  output logic f
);

  // Implement the function f using bitwise logic operations
  // Detect specific input patterns and assign corresponding outputs
  always_comb begin
    // Bitwise AND operations to detect specific input patterns
    // Directly assign output values based on the Karnaugh map
    f = (x == 4'b0000) | (x == 4'b1010) | (x == 4'b1101) | (x == 4'b1111);
  end

endmodule