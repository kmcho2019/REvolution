module TopModule (
  input [4:1] x,
  output logic f
);

  always_comb begin
    case (x)
      4'b0000: f = 1;  // Corresponds to f = 1 when x[4:1] = 0000
      4'b0001: f = 0;  // Corresponds to f = 0 when x[4:1] = 0001
      4'b0010: f = 1;  // Corresponds to f = 1 when x[4:1] = 0010
      4'b0011: f = 1;  // Corresponds to f = 1 when x[4:1] = 0011
      4'b0100: f = 1;  // Corresponds to f = 1 when x[4:1] = 0100
      4'b0101: f = 1;  // Corresponds to f = 1 when x[4:1] = 0101
      4'b0110: f = 1;  // Corresponds to f = 1 when x[4:1] = 0110
      4'b0111: f = 1;  // Corresponds to f = 1 when x[4:1] = 0111
      4'b1000: f = 1;  // Corresponds to f = 1 when x[4:1] = 1000
      4'b1001: f = 1;  // Corresponds to f = 1 when x[4:1] = 1001
      4'b1010: f = 1;  // Corresponds to f = 1 when x[4:1] = 1010
      4'b1011: f = 1;  // Corresponds to f = 1 when x[4:1] = 1011
      4'b1100: f = 1;  // Corresponds to f = 1 when x[4:1] = 1100
      4'b1101: f = 1;  // Corresponds to f = 1 when x[4:1] = 1101
      4'b1110: f = 1;  // Corresponds to f = 1 when x[4:1] = 1110
      4'b1111: f = 1;  // Corresponds to f = 1 when x[4:1] = 1111
      default: f = 0;  // Default output for any other input combination
    endcase
  end

endmodule