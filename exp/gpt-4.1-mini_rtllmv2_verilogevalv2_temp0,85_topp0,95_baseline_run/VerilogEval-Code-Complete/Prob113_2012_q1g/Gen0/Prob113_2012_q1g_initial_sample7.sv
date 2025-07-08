module TopModule (
  input [4:1] x,
  output logic f
);

  always_comb begin
    case (x)
      4'b0000: f = 1;
      4'b0010: f = 1;
      4'b1100: f = 1;
      4'b1101: f = 1;
      4'b1111: f = 1;
      4'b1000: f = 1;
      4'b1001: f = 1;
      4'b1010: f = 1;
      default: f = 0;
    endcase
  end

endmodule