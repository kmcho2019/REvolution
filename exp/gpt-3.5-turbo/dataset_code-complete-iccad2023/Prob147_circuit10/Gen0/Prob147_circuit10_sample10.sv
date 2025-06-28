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

always @(a, b, current_state) begin
  case (current_state)
    0: begin
      if (a == 0 && b == 0)
        next_state <= 0;
      else if (a == 0 && b == 1)
        next_state <= 1;
      else if (a == 1 && b == 0)
        next_state <= 2;
      else
        next_state <= 0;
    end
    1: begin
      next_state <= 0;
    end
    2: begin
      if (a == 1 && b == 1)
        next_state <= 3;
      else
        next_state <= 2;
    end
    3: begin
      next_state <= 1;
    end
    default: next_state <= 0; // Default to state 0
  endcase
end

always @(posedge clk) begin
  case (current_state)
    0: begin
      q <= 0;
      state <= 0;
    end
    1: begin
      q <= 1;
      state <= 1;
    end
    2: begin
      q <= 1;
      state <= 0;
    end
    3: begin
      q <= 0;
      state <= 1;
    end
    default: begin
      q <= 0;
      state <= 0;
    end
  endcase
end

endmodule