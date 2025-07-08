module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);
  // State encoding
  localparam S0 = 3'd0; // 0 consecutive ones (or after zero)
  localparam S1 = 3'd1; // 1 one
  localparam S2 = 3'd2; // 2 ones
  localparam S3 = 3'd3; // 3 ones
  localparam S4 = 3'd4; // 4 ones
  localparam S5 = 3'd5; // 5 ones
  localparam S6 = 3'd6; // 6 ones
  localparam S7 = 3'd7; // 7 or more ones (error)

  reg [2:0] state, next_state;

  // Moore outputs depend on current state only
  // disc: output when state = S5 and input is zero next clock cycle, so disc asserted in S5
  // flag: output when state = S6 (6 consecutive ones)
  // err: output when state = S7 (7 or more ones)

  // For Moore outputs, assert disc in S5 because the zero after 5 ones was detected last clock (transition to S5 followed by zero input)
  // However, since input zero causes transition back to S0, disc will be asserted in S5 state (after we see 5 ones), i.e. delayed by one clock cycle.

  // But this can be tricky: The input "0" after 5 ones causes disc. This means disc depends on previous input sequence ending with 5 ones followed by 0.
  // Since output is Moore type, output depends only on current state. We must assert disc in the state reached after receiving 0 after 5 ones.
  // That state is S0 (because input 0 after 5 ones goes to S0), so we cannot assert disc in S0 (because 0 after any number of ones leads to S0).
  // So we need to store a flag that disc condition happened to assert disc next cycle.

  // Solution: use an output register set in combinational logic from state and input, and output registers to assert outputs for one cycle.

  reg disc_reg, flag_reg, err_reg;

  always @(*) begin
    // Default next state
    case(state)
      S0: next_state = in ? S1 : S0;
      S1: next_state = in ? S2 : S0;
      S2: next_state = in ? S3 : S0;
      S3: next_state = in ? S4 : S0;
      S4: next_state = in ? S5 : S0;
      S5: next_state = in ? S6 : S0;
      S6: next_state = in ? S7 : S0;
      S7: next_state = in ? S7 : S0;
      default: next_state = S0;
    endcase
  end

  // Output logic (Moore) - outputs asserted one cycle after condition occurs
  always @(*) begin
    disc_reg = 1'b0;
    flag_reg = 1'b0;
    err_reg = 1'b0;

    // To assert disc: zero input after seeing 5 ones.
    // The zero after 5 ones causes transition from S5 to S0. We want disc to be asserted after that transition, i.e. when in S0 on the cycle after transition.
    // So we need to detect the transition from S5->S0 due to zero input and remember to assert disc next cycle.
    // Similarly for flag: 01111110 pattern means 6 consecutive ones + zero, so transition S6->S0 on zero input means flag condition.
    // Err condition: when state S7 (7+ ones), err is asserted.

    // Since Moore output depends only on state, we must do output registers that latch when condition detected.

    // However, in combinational logic we cannot access previous state.
    // Therefore, we detect conditions in synchronous block by comparing previous state and current input.

    // For combinational block, outputs depend only on state, so:
    // err asserted when in S7
    // disc and flag must be set using extra signal logic in sequential block.

  end

  // To handle disc and flag detection, we use two signals to detect transition from S5->S0 on zero input (disc)
  // and S6->S0 on zero input (flag).

  reg prev_state_S5, prev_state_S6;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      disc_reg <= 0;
      flag_reg <= 0;
      err_reg <= 0;
      prev_state_S5 <= 0;
      prev_state_S6 <= 0;
    end else begin
      state <= next_state;

      // Detect disc condition: previous state is S5 and input=0 (transition to S0)
      if (state == S5 && in == 1'b0)
        disc_reg <= 1'b1;
      else
        disc_reg <= 1'b0;

      // Detect flag condition: previous state S6 and input=0 (transition to S0)
      if (state == S6 && in == 1'b0)
        flag_reg <= 1'b1;
      else
        flag_reg <= 1'b0;

      // err asserted when in state S7
      err_reg <= (state == S7);
    end
  end

  assign disc = disc_reg;
  assign flag = flag_reg;
  assign err  = err_reg;

endmodule