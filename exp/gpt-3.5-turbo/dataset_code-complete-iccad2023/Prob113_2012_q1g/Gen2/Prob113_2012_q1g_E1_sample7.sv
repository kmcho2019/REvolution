module TopModule (
  input [4:1] x,
  output logic f
);

  always_comb begin
    case (x)
      4'b0000: f = 1; // Corresponds to minterm 1 in the K-map
      4'b0010: f = 1; // Corresponds to minterm 4 in the K-map
      4'b0011: f = 0; // Corresponds to minterm 3 in the K-map
      4'b1000: f = 0; // Corresponds to minterm 2 in the K-map
      4'b1010: f = 0; // Corresponds to minterm 7 in the K-map
      4'b1011: f = 1; // Corresponds to minterm 8 in the K-map
      4'b1100: f = 1; // Corresponds to minterm 6 in the K-map
      4'b1110: f = 0; // Corresponds to minterm 5 in the K-map
      default: f = 0; // Output 0 for all other cases not explicitly defined
    endcase
  end

endmodule