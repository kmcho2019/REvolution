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
      case ({x, y})
        6'b0_0_1_0_1: begin // Detect pattern 1, 0, 1 in x
          g <= 1;
          next_state = (y == 1) ? C : B; // If y becomes 1 within 2 clock cycles, maintain g = 1
        end
        default: begin
          g <= (y == 1) ? 1 : 0; // If y becomes 1 within 2 clock cycles, maintain g = 1 permanently
          next_state = B; // Reset to state B
        end
      endcase
    end
  endcase
end

endmodule