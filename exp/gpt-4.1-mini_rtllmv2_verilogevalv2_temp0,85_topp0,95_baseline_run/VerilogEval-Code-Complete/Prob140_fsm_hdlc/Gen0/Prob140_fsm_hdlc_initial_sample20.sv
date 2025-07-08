module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // State encoding: number of consecutive 1s seen since last 0
  // 0: no consecutive 1s (or last input was 0)
  // 1..6: 1..6 consecutive 1s
  typedef enum logic [2:0] {
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4,
    S5 = 3'd5,
    S6 = 3'd6,
    S7 = 3'd7  // 7 or more consecutive 1s (error state)
  } state_t;

  state_t state, next_state;

  // Outputs are Moore type: depend on state only
  // We assert outputs one cycle after detecting the pattern, so
  // outputs depend on current state only.

  assign disc = (state == S5); // Means we ended with 5 consecutive 1s then a 0 input, so disc on next cycle
  assign flag = (state == S6); // Means we ended with 6 consecutive 1s then a 0 input, so flag on next cycle
  assign err  = (state == S7); // Means 7 or more consecutive 1s detected

  always @(*) begin
    case(state)
      S0: begin
        if (in == 1'b1) next_state = S1;
        else           next_state = S0;
      end

      S1: begin
        if (in == 1'b1) next_state = S2;
        else           next_state = S0;
      end

      S2: begin
        if (in == 1'b1) next_state = S3;
        else           next_state = S0;
      end

      S3: begin
        if (in == 1'b1) next_state = S4;
        else           next_state = S0;
      end

      S4: begin
        if (in == 1'b1) next_state = S5;
        else           next_state = S0;
      end

      S5: begin
        if (in == 1'b1) next_state = S6;
        else           next_state = S0;
      end

      S6: begin
        if (in == 1'b1) next_state = S7; // 7 consecutive 1s, error
        else           next_state = S0;
      end

      S7: begin
        if (in == 1'b1) next_state = S7; // remain in error state while input is 1
        else           next_state = S0;
      end

      default: next_state = S0;
    endcase
  end

  // Synchronous reset and state update
  always @(posedge clk) begin
    if (reset)
      state <= S0;
    else
      state <= next_state;
  end

endmodule