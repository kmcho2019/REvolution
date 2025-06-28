module TopModule (
  input [4:1] x,
  output logic f
);
  
  always_comb begin
    case (x)
      4'b0000: f = 1; // Row 3, Column 1
      4'b0001: f = 0; // Row 1, Column 2
      4'b0010: f = 1; // Row 1, Column 3
      4'b0011: f = 0; // Row 2, Column 2
      4'b0100: f = 1; // Row 4, Column 1
      4'b0110: f = 1; // Row 3, Column 3
      4'b0111: f = 1; // Row 2, Column 3
      4'b1000: f = 1; // Row 4, Column 2
      4'b1001: f = 1; // Row 4, Column 3
      default: f = 0; // Default output value
    endcase
  end
  
endmodule