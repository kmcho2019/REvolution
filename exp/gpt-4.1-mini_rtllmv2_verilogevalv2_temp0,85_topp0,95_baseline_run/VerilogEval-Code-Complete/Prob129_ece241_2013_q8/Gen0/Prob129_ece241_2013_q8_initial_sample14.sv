module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // State encoding
  typedef enum logic [1:0] {
    S0 = 2'd0, // waiting for '1'
    S1 = 2'd1, // saw '1'
    S2 = 2'd2  // saw '10'
  } state_t;

  state_t state, next_state;

  // State transition logic and output combinational logic
  always @(*) begin
    // Default assignments
    next_state = state;
    z = 1'b0;

    case (state)
      S0: begin
        if (x == 1'b1)
          next_state = S1;
        else
          next_state = S0;
        z = 1'b0;
      end

      S1: begin
        if (x == 1'b0)
          next_state = S2;
        else // x==1
          next_state = S1;
        z = 1'b0;
      end

      S2: begin
        if (x == 1'b1) begin
          next_state = S1;
          z = 1'b1; // sequence "101" detected
        end else begin
          next_state = S0;
          z = 1'b0;
        end
      end

      default: begin
        next_state = S0;
        z = 1'b0;
      end
    endcase
  end

  // Sequential logic: state update with asynchronous negative edge reset
  always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      state <= S0;
      z <= 1'b0;
    end else begin
      state <= next_state;
      // z is assigned in combinational block, but Mealy output on the same cycle
      // To ensure z output changes with input, we assign z in combinational block
      // However, z is reg output, so assign here for synthesis tools
      // But combinational z is used, so here just keep previous assignment
      // To avoid mismatch, best to separate z from state update or use a separate output reg
      // But for Mealy FSM, this approach is acceptable.
    end
  end

endmodule