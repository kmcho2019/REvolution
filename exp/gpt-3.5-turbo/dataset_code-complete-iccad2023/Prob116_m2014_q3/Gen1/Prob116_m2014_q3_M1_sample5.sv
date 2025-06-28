module TopModule (
  input [4:1] x,
  output logic f
);

  always_comb begin
    case (x)
      4'b0000: f = 1;   // x[3]=0, x[2]=0
      4'b0001: f = 0;   // x[3]=0, x[2]=1
      4'b0011: f = 0;   // x[3]=1, x[2]=1
      4'b0010: f = 1;   // x[3]=1, x[2]=0
      default: f = 1'b0; // assigns any remaining cases to 0 (don't-care conditions)
    endcase
  end

endmodule