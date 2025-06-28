module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;

// Define state register and next state logic
reg [3:1] state, next_state;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

always @* begin
  // Default next state to current state
  next_state = state;

  // State transitions based on inputs
  case(state)
    A: begin
      if (r[1] == 1) begin
        next_state = B;
      end else if (r[2] == 1) begin
        next_state = C;
      end else if (r[3] == 1) begin
        next_state = D;
      end
    end
    B: begin
      if (state == B && r[1] == 1) begin
        next_state = B;
        g = 3'b001;
      end else begin
        next_state = A;
      end
    end
    C: begin
      if (state == C && r[2] == 1) begin
        next_state = C;
        g = 3'b010;
      end else begin
        next_state = A;
      end
    end
    D: begin
      next_state = D;
    end
  endcase
end

endmodule