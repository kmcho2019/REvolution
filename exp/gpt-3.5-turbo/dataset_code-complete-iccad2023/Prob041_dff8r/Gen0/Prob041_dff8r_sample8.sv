module DFlipFlop (
  input clk, 
  input d, 
  input reset, 
  output reg q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 8'b00000000;
  end else begin
    q <= d;
  end
end

endmodule

module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

genvar i;
generate
  for (i = 0; i < 8; i = i + 1) begin
    DFlipFlop DFF (
      .clk(clk),
      .d(d[i]),
      .reset(reset),
      .q(q[i])
    );
  end
endgenerate

endmodule