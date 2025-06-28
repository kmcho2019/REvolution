module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] current_state, next_state;

always @(posedge clk) begin
  current_state <= next_state;
  case(current_state)
    2'b00: begin
      next_state = (a & ~b) ? 2'b01 : 2'b00;
      q = 1'b0;
    end
    2'b01: begin
      next_state = (a & b) ? 2'b10 : 2'b01;
      q = 1'b1;
    end
    2'b10: begin
      next_state = (~a & ~b) ? 2'b11 : 2'b10;
      q = 1'b1;
    end
    2'b11: begin
      next_state = (a & b) ? 2'b00 : 2'b11;
      q = 1'b0;
    end
  endcase
end

initial begin
  state = 1'b0;
  current_state = 2'b00;
  next_state = 2'b00;
  q = 1'b0;
end

endmodule