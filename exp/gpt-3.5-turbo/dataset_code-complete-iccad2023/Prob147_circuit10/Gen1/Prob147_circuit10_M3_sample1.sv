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
  case (current_state)
    0: next_state = (a == 0 && b == 0) ? 0 :
                     (a == 0 && b == 1) ? 1 :
                     (a == 1 && b == 0) ? 2 : 0;
    1: next_state = 0;
    2: next_state = (a == 1 && b == 1) ? 3 : 2;
    3: next_state = 1;
    default: next_state = 0;
  endcase
end

always @* begin
  case (current_state)
    0: begin
      q = 0;
      state = 0;
    end
    1: begin
      q = 1;
      state = 1;
    end
    2: begin
      q = 1;
      state = 0;
    end
    3: begin
      q = 0;
      state = 1;
    end
    default: begin
      q = 0;
      state = 0;
    end
  endcase
end

endmodule