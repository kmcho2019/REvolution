module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    // Boolean expression derived from the simplified Karnaugh map
    out = (~c & ~d) | (~a & c) | (b & (c | d));
  end

endmodule