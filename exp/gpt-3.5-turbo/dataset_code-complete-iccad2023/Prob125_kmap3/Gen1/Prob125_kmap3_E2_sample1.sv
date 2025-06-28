module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    case ({c, d, a, b})
      4'b0000: out = 1; // Group of 1s at 00
      4'b0010: out = 0; // Group of 0s at 01
      4'b0110: out = 0; // Group of 0s at 01
      4'b0100: 
      4'b0101: 
      4'b0111: 
      4'b1010: out = 1; // Group of 1s at 10 and 11
      default: out = 1; // For don't-care cases 
    endcase
  end

endmodule