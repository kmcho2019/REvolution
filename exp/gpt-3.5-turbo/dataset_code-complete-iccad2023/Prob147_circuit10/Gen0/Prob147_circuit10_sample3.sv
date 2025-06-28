module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state;

always @(posedge clk) begin
  case({a, b})
    2'b00: begin
      next_state <= 1'b0;
      q <= 1'b0;
    end
    2'b01: begin
      next_state <= 1'b0;
      q <= 1'b1;
    end
    2'b10: begin
      next_state <= 1'b0;
      q <= 1'b1;
    end
    2'b11: begin
      next_state <= 1'b1;
      q <= 1'b1;
    end
  endcase
  state <= next_state;
end

endmodule