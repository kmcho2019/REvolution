module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [2:0] current_state, next_state;

always @(posedge clk) begin
  current_state <= next_state;
end

always @(*) begin
  case(current_state)
    3'b000: begin
      next_state = (a & ~b) ? 3'b001 : 3'b000;
      q = 1'b0;
    end
    3'b001: begin
      next_state = (a & ~b) ? 3'b001 : (a & b) ? 3'b010 : 3'b000;
      q = (next_state == 3'b010) ? 1'b1 : 1'b0;
    end
    3'b010: begin
      next_state = (a & b) ? 3'b011 : 3'b000;
      q = 1'b1;
    end
    3'b011: begin
      next_state = 3'b000;
      q = 1'b0;
    end
  endcase
end

initial begin
  state = 1'b0;
  current_state = 3'b000;
  next_state = 3'b000;
  q = 1'b0;
end

endmodule