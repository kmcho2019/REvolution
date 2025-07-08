module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);
  // State encoding
  localparam S0 = 3'd0; // 0 consecutive ones
  localparam S1 = 3'd1; // 1 consecutive one
  localparam S2 = 3'd2; // 2 consecutive ones
  localparam S3 = 3'd3; // 3 consecutive ones
  localparam S4 = 3'd4; // 4 consecutive ones
  localparam S5 = 3'd5; // 5 consecutive ones
  localparam S6 = 3'd6; // 6 consecutive ones (flag candidate)
  localparam S7 = 3'd7; // error state (7 or more ones)

  reg [2:0] state, next_state;

  // State transition logic
  always @(*) begin
    // Default next state same as current
    next_state = state;
    case(state)
      S0: begin
        if(in)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if(in)
          next_state = S2;
        else
          next_state = S0;
      end
      S2: begin
        if(in)
          next_state = S3;
        else
          next_state = S0;
      end
      S3: begin
        if(in)
          next_state = S4;
        else
          next_state = S0;
      end
      S4: begin
        if(in)
          next_state = S5;
        else
          next_state = S0;
      end
      S5: begin
        if(in)
          next_state = S6;
        else
          next_state = S0; // disc detected on transition from S5 to S0 with in=0
      end
      S6: begin
        if(in)
          next_state = S7; // error detected (7 or more ones)
        else
          next_state = S0; // flag detected on transition from S6 to S0 with in=0
      end
      S7: begin
        // Remain in error state regardless of input
        next_state = S7;
      end
      default: next_state = S0;
    endcase
  end

  // State register with synchronous reset
  always @(posedge clk) begin
    if(reset)
      state <= S0;
    else
      state <= next_state;
  end

  // Output logic: Moore type - outputs depend only on current state
  always @(*) begin
    // Defaults
    disc = 1'b0;
    flag = 1'b0;
    err  = 1'b0;

    // disc output asserted for one cycle after disc event (transition S5->S0 on input=0)
    // flag output asserted for one cycle after flag event (transition S6->S0 on input=0)
    // err output asserted in state S7

    // Since outputs are asserted after the condition occurs, 
    // and FSM transitions to S0 in both disc and flag conditions,
    // we detect disc or flag by remembering previous state or by encoding outputs in next state

    // To avoid complexity, we can detect disc and flag by checking the previous state (state before S0)
    // However, previous state is not stored, so we will infer outputs based on next_state and input.

    // Instead, we will create separate registers to detect events synchronously.

  end

  reg prev_state_S5;
  reg prev_state_S6;

  always @(posedge clk) begin
    if(reset) begin
      disc <= 0;
      flag <= 0;
      err  <= 0;
      prev_state_S5 <= 0;
      prev_state_S6 <= 0;
    end else begin
      // disc if last state was S5 and input=0 (transition to S0)
      disc <= (state == S0) && (prev_state_S5);

      // flag if last state was S6 and input=0 (transition to S0)
      flag <= (state == S0) && (prev_state_S6);

      // err if in error state
      err <= (state == S7);

      // Update prev_state_S5 and prev_state_S6 flags for next cycle
      prev_state_S5 <= (state == S5) && (in == 1'b0);
      prev_state_S6 <= (state == S6) && (in == 1'b0);
    end
  end

endmodule