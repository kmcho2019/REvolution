module TopModule (
  input [4:1] x,
  output logic f
);

  always_comb begin
    case (x)
      4'b0000, 4'b0011, 4'b0110, 4'b0111, 4'b0101: f = 1;
      4'b0001, 4'b0010, 4'b0100: f = 0;
      default: f = 0; // for other input combinations not covered explicitly
    endcase
  end

endmodule