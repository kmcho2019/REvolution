module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @*
    case ({c, d, a, b})
      4'b0000: out = 1;
      4'b0010: out = 0;
      4'b0100: out = 1;
      4'b0101: out = 1;
      4'b0110: out = 0;
      4'b0111: out = 0;
      4'b1010: out = 1;
      default: out = 0; // don't care cases
    endcase

endmodule