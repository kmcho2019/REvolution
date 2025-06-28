module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// State encoding: A=01, B=10
reg [1:0] state, next_state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 2'b01; // Initial state A
  end else begin
    state <= next_state; // Update state
  end
end

always @* begin
  case (state)
    2'b01: begin // State A
      if (x) begin
        next_state = 2'b10; // Transition to state B when x=1
        z = 1; // Output z=1 when x=1
      end else begin
        next_state = 2'b01; // Stay in state A when x=0
        z = 0; // Output z=0 when x=0
      end
    end
    2'b10: begin // State B
      if (x) begin
        next_state = 2'b10; // Stay in state B when x=1
        z = 0; // Output z=0 when x=1
      end else begin
        next_state = 2'b10; // Stay in state B when x=0
        z = 1; // Output z=1 when x=0
      end
    end
    default: begin
      next_state = 2'b01;
      z = 0;
    end
  endcase
end

endmodule