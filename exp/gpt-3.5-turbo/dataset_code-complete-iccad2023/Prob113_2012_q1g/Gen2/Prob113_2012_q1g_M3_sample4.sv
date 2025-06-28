module TopModule (
  input [4:1] x,
  output logic f
);

  always_comb begin
    case (x)
      4'b0000, 4'b1011, 4'b0101, 4'b1101: f = 1; // Group of 1s: 0000, 1011, 0101, 1101
      4'b1100, 4'b1010, 4'b0010, 4'b1000: f = 0; // Group of 1s: 1100, 1010, 0010, 1000
      default: f = 0;
    endcase
  end

endmodule