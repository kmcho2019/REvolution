module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

reg [1:0] state;

always_comb begin
  case (state)
    2'd0: state = in ? 2'd1 : 2'd0;
    2'd1: state = in ? 2'd1 : 2'd2;
    2'd2: state = in ? 2'd3 : 2'd0;
    2'd3: state = in ? 2'd1 : 2'd2;
  endcase
end

always_ff @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 2'd0;
  end else begin
    case (state)
      2'd0: state <= in ? 2'd1 : 2'd0;
      2'd1: state <= in ? 2'd1 : 2'd2;
      2'd2: state <= in ? 2'd3 : 2'd0;
      2'd3: state <= in ? 2'd1 : 2'd2;
    endcase
  end
end

assign out = (state == 2'd3);

endmodule