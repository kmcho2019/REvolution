module MooreStateMachine (
  input clk,
  input j,
  input k,
  input areset,
  output reg out
);

  // Define states
  parameter OFF = 1'b0;
  parameter ON = 1'b1;
  
  // State register
  reg state, next_state;
  
  // Moore state machine logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= OFF; // Reset to state OFF
    end
    else begin
      state <= next_state; // Update state based on next_state
    end
  end
  
  // State transitions and outputs
  always @(state, j, k) begin
    case(state)
      OFF: begin
        if (j) next_state = ON;
        else next_state = OFF;
        out = 1'b0;
      end
      ON: begin
        if (k) next_state = OFF;
        else next_state = ON;
        out = 1'b1;
      end
    endcase
  end

endmodule