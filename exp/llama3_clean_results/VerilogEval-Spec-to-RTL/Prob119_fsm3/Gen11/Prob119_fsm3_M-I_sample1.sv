module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

reg [1:0] state;
reg [1:0] next_state;

always_comb begin
  case (state)
    2'd0: next_state = in ? 2'd1 : 2'd0;
    2'd1: next_state = in ? 2'd1 : 2'd2;
    2'd2: next_state = in ? 2'd3 : 2'd0;
    2'd3: next_state = in ? 2'd1 : 2'd2;
    default: next_state = 2'd0;
  endcase
end

always_ff @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 2'd0;
  end else begin
    state <= next_state;
  end
end

assign out = (state == 2'd3);

endmodule