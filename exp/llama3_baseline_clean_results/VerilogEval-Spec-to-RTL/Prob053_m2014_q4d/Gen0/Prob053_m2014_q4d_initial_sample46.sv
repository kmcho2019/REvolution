module TopModule(clk, in, out);
  input clk;
  input in;
  output out;
  reg out;

  always @(posedge clk) begin
    out <= in ^ out;
  end

  // No need for a continuous assignment as the XOR result is already assigned to out
endmodule