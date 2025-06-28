module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state, current_state;

always @(posedge clk) begin
  current_state <= next_state;
end

always @* begin
  case ({a, b})
    2'b00: next_state = current_state;
    2'b01: next_state = 1'b0;
    2'b10: next_state = 1'b0;
    2'b11: next_state = ~current_state;
  endcase
end

always @(posedge clk) begin
  case (current_state)
    1'b0: begin
      q <= 1'b0;
      state <= 1'b0;
    end
    1'b1: begin
      q <= 1'b1;
      state <= 1'b1;
    end
  endcase
end

endmodule