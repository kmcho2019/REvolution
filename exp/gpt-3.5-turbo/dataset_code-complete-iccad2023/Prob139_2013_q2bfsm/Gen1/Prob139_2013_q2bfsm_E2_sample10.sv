module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

typedef enum logic [1:0] {
  STATE_A,
  STATE_B,
  STATE_C,
  STATE_D
} fsm_state;

reg [1:0] state, next_state;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= STATE_A;
  end else begin
    state <= next_state;
  end
end

always @* begin
  case (state)
    STATE_A: begin
      next_state = (resetn == 0) ? STATE_A : STATE_B;
      f = 0;
      g = 0;
    end
    STATE_B: begin
      next_state = STATE_C;
      f = 1;
      g = 0;
    end
    STATE_C: begin
      if ((x == 1) && (y == 0) && ($past(x) == 1)) begin
        next_state = STATE_D;
        g = 1;
      end else begin
        next_state = STATE_C;
        g = 0;
      end
    end
    STATE_D: begin
      if (y) begin
        g = 1;
      end else begin
        g = 0;
      end
      next_state = STATE_D;
    end
    default: begin
      next_state = STATE_A;
      f = 0;
      g = 0;
    end
  endcase
end

endmodule