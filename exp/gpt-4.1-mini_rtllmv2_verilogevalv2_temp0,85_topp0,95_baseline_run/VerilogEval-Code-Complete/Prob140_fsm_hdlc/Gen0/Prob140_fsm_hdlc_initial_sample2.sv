module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // States count number of consecutive 1s after last 0
  // 0: no consecutive 1s yet
  // 1..6: count of consecutive 1s
  // 7: error state (7 or more consecutive 1s)
  reg [3:0] state, next_state;

  // State encoding:
  localparam S0 = 4'd0;  // no 1s
  localparam S1 = 4'd1;
  localparam S2 = 4'd2;
  localparam S3 = 4'd3;
  localparam S4 = 4'd4;
  localparam S5 = 4'd5;  // 5 consecutive 1s
  localparam S6 = 4'd6;  // 6 consecutive 1s
  localparam S7 = 4'd7;  // error: 7 or more consecutive 1s

  // Outputs are registered, assigned based on current state and input
  // In Moore FSM, output depends on state only, but in this problem,
  // outputs depend on transitions that happen on next input,
  // so outputs are asserted one cycle after detecting the pattern.
  // We implement output logic so that when in state S5 and input=0,
  // disc is asserted next cycle, etc.

  // To achieve this, outputs are assigned based on previous cycle's detection:
  // We'll detect transitions in next_state logic and store output flags accordingly.

  reg disc_next, flag_next, err_next;

  always @(*) begin
    // Default next state is current state
    next_state = state;
    disc_next = 1'b0;
    flag_next = 1'b0;
    err_next = 1'b0;

    case (state)
      S0: begin
        if (in == 1'b1) next_state = S1;
        else next_state = S0;
      end
      S1: begin
        if (in == 1'b1) next_state = S2;
        else next_state = S0;
      end
      S2: begin
        if (in == 1'b1) next_state = S3;
        else next_state = S0;
      end
      S3: begin
        if (in == 1'b1) next_state = S4;
        else next_state = S0;
      end
      S4: begin
        if (in == 1'b1) next_state = S5;
        else next_state = S0;
      end
      S5: begin
        if (in == 1'b1) next_state = S6;
        else begin
          next_state = S0;
          disc_next = 1'b1; // 5 ones followed by 0: discard bit
        end
      end
      S6: begin
        if (in == 1'b1) next_state = S7;
        else begin
          next_state = S0;
          flag_next = 1'b1; // 6 ones followed by 0: flag
        end
      end
      S7: begin
        if (in == 1'b1) next_state = S7; // stay in error state
        else next_state = S0;
        err_next = 1'b1; // 7 or more ones: error
      end
      default: next_state = S0;
    endcase
  end

  // Synchronous reset and state update
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
    end else begin
      state <= next_state;
      disc <= disc_next;
      flag <= flag_next;
      err <= err_next;
    end
  end

endmodule