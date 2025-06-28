module TopModule (
  input [4:1] x,
  output logic f
);
  
  always_comb begin
    case ({x[3], x[4]})
      2'b00: f = 1; // Row 4, Column 1
      2'b01: f = x[1]; // Row 1, Column 2
      2'b10: f = x[3] | x[4]; // Row 2, Column 3, 3
      2'b11: f = 1; // Row 1, Column 3
      default: f = 0; // Default output value
    endcase
  end
  
endmodule