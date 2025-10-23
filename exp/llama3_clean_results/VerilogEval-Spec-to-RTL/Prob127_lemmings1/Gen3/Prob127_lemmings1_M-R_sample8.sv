module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

reg walk_state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    walk_state <= 0;
  end else begin
    case ({bump_left, bump_right})
      2'b00: walk_state <= walk_state;
      2'b01: walk_state <= 0;
      2'b10: walk_state <= 1;
      2'b11: walk_state <= ~walk_state;
    endcase
  end
end

assign walk_left = ~walk_state;
assign walk_right = walk_state;

endmodule