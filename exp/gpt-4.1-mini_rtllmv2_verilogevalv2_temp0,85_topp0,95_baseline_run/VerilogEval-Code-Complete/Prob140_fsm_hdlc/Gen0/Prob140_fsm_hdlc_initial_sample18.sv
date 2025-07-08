module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // State encoding: count of consecutive ones seen so far (0 to 7+)
  typedef enum logic [3:0] {
    S0 = 4'd0, // no consecutive ones
    S1 = 4'd1,
    S2 = 4'd2,
    S3 = 4'd3,
    S4 = 4'd4,
    S5 = 4'd5,
    S6 = 4'd6,
    S7 = 4'd7 // 7 or more consecutive ones (error)
  } state_t;

  state_t state, next_state;

  // Outputs registered for Moore FSM (based on current state)
  logic disc_reg, flag_reg, err_reg;

  // Next state logic
  always_comb begin
    // default next state
    next_state = S0;

    case(state)
      S0: next_state = in ? S1 : S0;
      S1: next_state = in ? S2 : S0;
      S2: next_state = in ? S3 : S0;
      S3: next_state = in ? S4 : S0;
      S4: next_state = in ? S5 : S0;
      S5: next_state = in ? S6 : S0;
      S6: next_state = in ? S7 : S0; // error if input is 1 again
      S7: next_state = S7; // stay in error state
      default: next_state = S0;
    endcase
  end

  // Output logic (Moore) - outputs depend only on current state
  // disc: occurs when zero after 5 consecutive ones (state was S5, input zero)
  // flag: occurs when zero after 6 consecutive ones (state was S6, input zero)
  // err: when in state S7 (7+ consecutive ones)
  // Since outputs are asserted on cycle after event, store outputs based on previous state and input
  // We implement outputs by registering the previous state and input and generating signals accordingly

  // To achieve output one cycle after event, we store previous state and input
  state_t prev_state;
  logic prev_in;

  always_ff @(posedge clk) begin
    if (reset) begin
      state <= S0;
      prev_state <= S0;
      prev_in <= 1'b0;
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;
    end else begin
      state <= next_state;

      // Save previous state and input for output detection on this cycle
      prev_state <= state;
      prev_in <= in;

      // Generate outputs on cycle after the pattern detection
      disc_reg <= (prev_state == S5) && (prev_in == 1'b0);
      flag_reg <= (prev_state == S6) && (prev_in == 1'b0);
      err_reg  <= (prev_state == S7);
    end
  end

  assign disc = disc_reg;
  assign flag = flag_reg;
  assign err  = err_reg;

endmodule