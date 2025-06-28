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
end

always @(*) begin
  case (current_state)
    2'b00: begin
      q = 0;
      state = 0;
      if (a == 0 && b == 0)
        next_state = 2'b00;
      else if (a == 0 && b == 1)
        next_state = 2'b01;
      else if (a == 1 && b == 0)
        next_state = 2'b10;
      else
        next_state = 2'b00;
    end
    2'b01: begin
      q = 1;
      state = 0;
      next_state = 2'b00;
    end
    2'b10: begin
      q = 1;
      state = 1;
      if (a == 1 && b == 1)
        next_state = 2'b11;
      else
        next_state = 2'b10;
    end
    2'b11: begin
      q = 0;
      state = 1;
      next_state = 2'b01;
    end
    default: begin
      q = 0;
      state = 0;
      next_state = 2'b00;
    end
  endcase
end

endmodule