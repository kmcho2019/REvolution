module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    case ({c, d, a, b})
      4'b0000, 4'b0010, 4'b0110, 4'b0111 : out = 0;
      4'b0001, 4'b0100, 4'b0101, 4'b1000, 4'b1001, 4'b1100, 4'b1101 : out = 1;
      default: out = 0; // handle don't-care cases
    endcase
  end

endmodule