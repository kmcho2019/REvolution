module TopModule (
  input [4:1] x,
  output logic f
);

  // Implementing the function f using a case statement to directly match input patterns
  always_comb begin
    case (x)
      4'b0000: f = 1; // 00 00
      4'b0001: f = 0; // 00 01
      4'b0011: f = 0; // 00 11
      4'b0010: f = 1; // 00 10
      4'b1100: f = 1; // 11 00
      4'b1101: f = 1; // 11 01
      4'b1111: f = 1; // 11 11
      4'b1110: f = 0; // 11 10
      4'b1010: f = 1; // 10 10
      default: f = 0; // All other cases
    endcase
  end

endmodule