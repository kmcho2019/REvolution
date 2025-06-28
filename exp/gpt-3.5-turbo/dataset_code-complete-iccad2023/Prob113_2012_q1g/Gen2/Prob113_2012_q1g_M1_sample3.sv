module TopModule (
  input [4:1] x,
  output logic f
);

  always_comb begin
    case (x)
      4'b0000: f = 1; // minterm1
      4'b0100: f = 1; // minterm2
      4'b1100: f = 1; // minterm3
      4'b1000: f = 0; // minterm4
      4'b1010: f = 1; // minterm5
      4'b1110: f = 0; // minterm6
      4'b0111: f = 1; // minterm7
      4'b0110: f = 1; // minterm8
      default: f = 0; // for other cases not explicitly defined
    endcase
  end

endmodule