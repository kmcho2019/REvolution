module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state;

always @(posedge clk) begin
  state <= next_state;
  case(state)
    2'b00: begin
      next_state = (a & ~b) ? 2'b01 : 2'b00;
      q <= 1'b0;
    end
    2'b01: begin
      next_state = (a & b) ? 2'b10 : 2'b01;
      q <= 1'b1;
    end
    2'b10: begin
      next_state = (~a & ~b) ? 2'b11 : 2'b10;
      q <= 1'b1;
    end
    2'b11: begin
      next_state = (a & b) ? 2'b00 : 2'b11;
      q <= 1'b0;
    end
  endcase
end

initial begin
  state <= 2'b00;
  q <= 1'b0;
end

endmodule