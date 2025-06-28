module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg q
);
  
  always @* begin
    if (d | (b & (a ^ c))) begin
      q = 1;
    end
    else begin
      q = 0;
    end
  end

endmodule