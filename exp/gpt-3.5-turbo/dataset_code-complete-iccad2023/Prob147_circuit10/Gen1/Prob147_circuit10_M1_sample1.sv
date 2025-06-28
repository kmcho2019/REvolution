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
      if (a == 1 && b == 0)
        next_state <= 2;
      else if (a == 1 && b == 1)
        next_state <= 1;
      else
        next_state <= 0;
    end
    2'b01: begin
      next_state <= 0;
    end
    2'b10: begin
      if (a == 0 && b == 0)
        next_state <= 0;
      else if (a == 0 && b == 1)
        next_state <= 1;
      else
        next_state <= 2;
    end
    default: next_state <= 0; // Default to state 00
  endcase
end

always @(posedge clk) begin
  case (current_state)
    2'b00: begin
      q <= 0;
      state <= 0;
    end
    2'b01: begin
      q <= 1;
      state <= 1;
    end
    2'b10: begin
      q <= 1;
      state <= 0;
    end
    default: begin
      q <= 0;
      state <= 0;
    end
  endcase
end

endmodule