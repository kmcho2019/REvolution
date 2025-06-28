module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// FSM states
parameter A = 2'b00, B = 2'b01, C = 2'b10;
reg [1:0] state, next_state;
reg [2:0] x_pattern;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
    f <= 0;
    g <= 0;
    x_pattern <= 3'b0;
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
      x_pattern <= 3'b0;
      next_state = resetn ? A : B;
    end
    B: begin
      f <= 1;
      g <= 0;
      x_pattern <= 3'b0;
      next_state = C;
    end
    C: begin
      case (x_pattern)
        3'b101: begin
          g <= 1;
          x_pattern <= 3'b0;
          next_state = C;
        end
        default: begin
          x_pattern <= {x_pattern[1:0], x};
          if (x_pattern == 3'b101)
            next_state = C;
          else begin
            if (y == 1)
              g <= 1;
            else
              g <= 0;
            next_state = C;
          end
        end
      endcase
    end
  endcase
end

endmodule