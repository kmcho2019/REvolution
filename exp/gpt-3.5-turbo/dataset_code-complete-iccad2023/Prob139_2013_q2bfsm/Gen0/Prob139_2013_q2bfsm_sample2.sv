module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State and next state
reg [1:0] state, next_state;

// State register
always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;  // Initial state
  end else begin
    state <= next_state;
  end
end

// Next state logic
always @(state, resetn, x, y) begin
  case (state)
    A: begin
      next_state = (resetn) ? B : A;
    end
    B: begin
      next_state = C;
    end
    C: begin
      if (x == 1 && ($past(x) == 0) && ($past($past(x)) == 1)) begin
        next_state = D;
      end else begin
        next_state = C;
      end
    end
    D: begin
      if (y == 1 || $past(y) == 1) begin
        next_state = D;
      end else if (($past(y, 2) == 0 && $past(y) == 0) || ($past(y) == 1 && $past(y, 2) == 0)) begin
        next_state = C;
      end else begin
        next_state = D;
      end
    end
    default: begin
      next_state = A;
    end
  endcase
end

// Output logic
always @* begin
  case (state)
    A: begin
      f = 0;
      g = 0;
    end
    B: begin
      f = 1;
      g = 0;
    end
    C: begin
      f = 0;
      g = 0;
    end
    D: begin
      f = 0;
      g = 1;
    end
  endcase
end

endmodule