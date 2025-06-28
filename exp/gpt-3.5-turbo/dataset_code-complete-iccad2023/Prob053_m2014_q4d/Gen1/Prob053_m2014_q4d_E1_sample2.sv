module XOR_DFF (
  input d, clk,
  output reg q
);
  reg internal_d;

  always @(posedge clk) begin
    internal_d <= d ^ q;
  end

  always @(posedge clk) begin
    q <= internal_d;
  end
endmodule

module TopModule (
  input clk,
  input in,
  output reg out
);
  wire xor_out;
  
  XOR_DFF xor_dff (.d(in), .clk(clk), .q(xor_out));
  
  always @(posedge clk) begin
    out <= xor_out;
  end
endmodule