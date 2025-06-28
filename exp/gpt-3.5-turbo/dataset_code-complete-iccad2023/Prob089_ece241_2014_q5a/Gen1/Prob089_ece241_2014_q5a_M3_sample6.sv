module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

reg state = 1'b0;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 1'b0;
    z <= 1'b0;
  end else begin
    case(state)
      1'b0: begin // IDLE state
        if (x == 1'b1)
          state <= 1'b1;
      end
      1'b1: begin // CONVERT state
        z <= ~z;
        if (x == 1'b0)
          state <= 1'b0;
      end
    endcase
  end
end

endmodule