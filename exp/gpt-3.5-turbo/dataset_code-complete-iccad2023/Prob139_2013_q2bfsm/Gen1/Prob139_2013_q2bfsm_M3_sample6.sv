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
      case ({x, state})
        4'b1010: begin
          g <= (g | y);
          next_state = C;
        end
        {2'b00, state[0]}: begin
          g <= 0;
          next_state = C;
        end
        default: begin
          f <= 0;
          g <= 1;
          next_state = B;
        end
      endcase
    end
  endcase
end

endmodule