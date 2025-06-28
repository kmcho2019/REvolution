module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states for the Moore machine
parameter S_IDLE = 2'b00;
parameter S_NEGATE = 2'b01;
parameter S_COMPLEMENT = 2'b10;

reg [1:0] state, next_state;

always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= S_IDLE; // Initialize to idle state
    z <= 1'b0; // Output is 0 when in idle state
  end
  else begin
    state <= next_state;
  end
end

always @ (*) begin
  case (state)
    S_IDLE: begin
      if (x == 1'b1)
        next_state = S_NEGATE; // Switch to negate state if input is 1
      else
        next_state = S_IDLE; // Stay in idle state if input is 0
      z = 1'b0; // Output is 0 in idle state
    end
    S_NEGATE: begin
      next_state = S_COMPLEMENT; // Move to complement state to perform 2's complement
      z = 1'b1; // Output is 1 when in negate state
    end
    S_COMPLEMENT: begin
      next_state = S_COMPLEMENT; // Stay in complement state while performing 2's complement
      z = ~z; // Perform 2's complement operation on the output
    end
    default: begin
      next_state = S_IDLE; // Default to idle state
      z = 1'b0; // Default output to 0
    end
  endcase
end

endmodule