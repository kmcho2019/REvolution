module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg current_state, next_state;

always @(posedge clk) begin
  current_state <= next_state;
end

always @(*) begin
  case(current_state)
    1'b0: begin
      next_state = (a & ~b) ? 1'b1 : 1'b0;
      q = 1'b0;
    end
    1'b1: begin
      next_state = (a & b) ? 1'b2 : 1'b1;
      q = (b) ? 1'b1 : 1'b0;
    end
    1'b2: begin
      next_state = (~a & ~b) ? 1'b3 : 1'b2;
      q = (a) ? 1'b1 : 1'b0;
    end
    1'b3: begin
      next_state = (a & b) ? 1'b0 : 1'b3;
      q = 1'b1;
    end
  endcase
end

initial begin
  state = 1'b0;
  current_state = 1'b0;
  next_state = 1'b0;
  q = 1'b0;
end

endmodule