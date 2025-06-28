module TopModule (
  input [3:0] x,
  output logic f
);

  always_comb begin
    // Grouping minterms from the K-map to minimize conditions
    case (x)
      4'b0000, 4'b0110, 4'b0101, 4'b0111: f = 1; // Group 1 - minterms (0000, 0110, 0101, 0111)
      4'b0011, 4'b1011: f = 1; // Group 2 - minterms (0011, 1011)
      4'b1000, 4'b1100, 4'b1010: f = 1; // Group 3 - minterms (1000, 1100, 1010)
      default: f = 0; // For other cases not explicitly defined
    endcase
  end

endmodule