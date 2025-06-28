module dff_with_reset (
  input clk,
  input d,
  input areset,
  output reg q
);

always @(posedge clk or posedge areset) begin
  if (areset) begin
    q <= 0;
  end else begin
    q <= d;
  end
end

endmodule

module TopModule (
  input clk,
  input [7:0] d,
  input areset,
  output reg [7:0] q
);

reg [7:0] d_reg;

// Instantiate 8 D flip-flops with reset
dff_with_reset dff_inst [7:0] (
  .clk(clk),
  .d(d_reg),
  .areset(areset),
  .q(q[0])
);

// Connect data input (d) to the first flip-flop D input
always @(*) begin
  d_reg = d;
end

// Cascade output of each flip-flop to the input of the next
always @(*) begin
  q[1] <= dff_inst[0].q;
  q[2] <= dff_inst[1].q;
  q[3] <= dff_inst[2].q;
  q[4] <= dff_inst[3].q;
  q[5] <= dff_inst[4].q;
  q[6] <= dff_inst[5].q;
  q[7] <= dff_inst[6].q;
end

endmodule