module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    case ({a, b, c, d})
      4'b0000, 4'b0010, 4'b0110, 4'b1010, 4'b1110: out = 1;
      4'b0001: out = 0;
      4'b0011, 4'b0111, 4'b1011, 4'b1111: out = 1;
      default: out = 0; // for don't-care values
    endcase
  end

endmodule