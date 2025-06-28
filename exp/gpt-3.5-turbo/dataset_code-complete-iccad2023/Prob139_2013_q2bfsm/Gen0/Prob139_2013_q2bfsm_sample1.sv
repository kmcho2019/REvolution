module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// Define states
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
reg [2:0] state, next_state;

// State transition and output logic
always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
    f <= 0;
    g <= 0;
  end
  else begin
    state <= next_state;
    case(state)
      A: begin
        if (resetn)
          next_state = B;
        else begin
          next_state = A;
          f <= 0;
          g <= 0;
        end
      end
      B: begin
        next_state = C;
        f <= 1;
        g <= 0;
      end
      C: begin
        if ((x == 1) && ($past(x) == 0) && ($past($past(x)) == 1))
          next_state = D;
        else
          next_state = C;
        g <= 0;
      end
      D: begin
        if (y == 1) begin
          next_state = E;
          g <= 1;
        end
        else
          next_state = F;
      end
      E: begin
        if (y == 1)
          next_state = E;
        else
          next_state = F;
        g <= 1;
      end
      F: begin
        next_state = F;
        g <= 0;
      end
    endcase
  end
end

endmodule