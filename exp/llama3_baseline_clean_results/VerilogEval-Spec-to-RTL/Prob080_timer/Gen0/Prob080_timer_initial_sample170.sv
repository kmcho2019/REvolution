module TopModule (
  input           clk,
  input           load,
  input   [9:0]   data,
  output          tc
);

  reg [9:0] count;
  wire  [9:0] next_count;

  // Calculate next count
  assign next_count = load ? data : (count == 10'd0) ? 10'd0 : count - 10'd1;

  // Update count on positive clock edge
  always @(posedge clk) begin
    count <= next_count;
  end

  // Assert tc when count is 0
  assign tc = (count == 10'd0) ? 1'b1 : 1'b0;

endmodule