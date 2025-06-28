module SerialTwosComplementer (
  input clk,
  input areset,
  input x,
  output reg z
);

  // Define the states for the Moore machine
  typedef enum logic [1:0] {
    INITIAL_STATE,
    NEGATE_STATE,
    COMPLEMENT_STATE
  } STATE;

  // Define the state register and next state logic
  reg [1:0] state, next_state;
  
  // Define a register to store the previous input bit
  reg prev_x;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Initialize the state machine
      state <= INITIAL_STATE;
      z <= 1'b0;
      prev_x <= 1'b0;
    end else begin
      // State machine transition logic
      state <= next_state;
    end
  end

  always @* begin
    // Default next state
    next_state = state;

    // Logic for the Moore state transitions
    case (state)
      INITIAL_STATE:
        begin
          if (!areset && x == 1'b1) begin
            next_state = NEGATE_STATE;
          end
        end
      NEGATE_STATE:
        begin
          if (!areset) begin
            if (x != prev_x) begin
              next_state = COMPLEMENT_STATE;
            end
          end
        end
      COMPLEMENT_STATE:
        begin
          if (!areset) begin
            z <= ~z; // Perform the 2's complement
            prev_x <= x;
            next_state = NEGATE_STATE;
          end
        end
    endcase
  end

endmodule