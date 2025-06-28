module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    casez({c, d})
      2'b00: out = 1;
      2'b01: out = 0;
      2'b10: out = a;
      2'b11: out = 1;
    endcase
  end

endmodule