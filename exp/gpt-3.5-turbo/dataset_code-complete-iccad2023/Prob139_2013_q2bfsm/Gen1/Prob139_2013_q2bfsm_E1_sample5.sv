module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// FSM states
parameter RESET = 2'b00, SET_F = 2'b01, DETECT_X = 2'b10, DETECT_Y = 2'b11;
reg [1:0] state, next_state;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= RESET;
    f <= 0;
    g <= 0;
  end
  else begin
    state <= next_state;
  end
end

always @* begin
  case (state)
    RESET: begin
      f <= 0;
      g <= 0;
      next_state = resetn ? RESET : SET_F;
    end
    SET_F: begin
      f <= 1;
      g <= 0;
      next_state = DETECT_X;
    end
    DETECT_X: begin
      if (x == 1 && $rose(clk)) begin
        next_state = DETECT_Y;
      end
      else begin
        next_state = DETECT_X;
      end
    end
    DETECT_Y: begin
      if (y == 1 && $rose(clk)) begin
        g <= 1;
        next_state = DETECT_Y;
      end
      else if ($past(y) == 1 && y == 0) begin
        g <= 0;
        next_state = DETECT_Y;
      end
      else begin
        g <= g;
        next_state = DETECT_Y;
      end
    end
  endcase
end

endmodule