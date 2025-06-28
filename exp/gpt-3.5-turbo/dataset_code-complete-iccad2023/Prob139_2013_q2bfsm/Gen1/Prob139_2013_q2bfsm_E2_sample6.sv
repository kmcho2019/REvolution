module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// FSM states
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
reg [1:0] state, next_state;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
    f <= 0;
    g <= 0;
  end
  else begin
    state <= next_state;
  end
end

always @* begin
  case (state)
    A: begin
      f <= 0;
      g <= 0;
      next_state = resetn ? A : B;
    end
    B: begin
      f <= 1;
      g <= 0;
      next_state = C;
    end
    C: begin
      if ((state == C) && (x == 1) && ($past(x) == 0) && ($past($past(x)) == 1))
        g <= 1;
      else
        g <= 0;
      if (y == 1)
        next_state = D;
      else
        next_state = C;
    end
    D: begin
      if (y == 1)
        g <= 1;
      else
        g <= 0;
      next_state = D;
    end
  endcase
end

endmodule