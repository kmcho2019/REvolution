module TopModule (
  input [4:1] x,
  output logic f
);
  
  always_comb begin
    case (x)
      4'b0000, 4'b0110, 4'b0111, 4'b1000, 4'b1001: f = 1; // Output 1 for these combinations
      4'b0001, 4'b0010, 4'b0100, 4'b1010: f = 0; // Output 0 for these combinations
      default: f = 0; // Default output value for other cases
    endcase
  end
  
endmodule