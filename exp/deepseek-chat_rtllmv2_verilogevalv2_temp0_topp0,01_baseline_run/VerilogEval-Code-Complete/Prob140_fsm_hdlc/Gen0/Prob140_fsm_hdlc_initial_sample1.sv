module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // Define states
  typedef enum logic [2:0] {
    S0, S1, S2, S3, S4, S5, S6, S7
  } state_t;

  state_t current_state, next_state;

  // State transition logic
  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= S0;
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic
  always_comb begin
    case (current_state)
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

  // Output logic (Moore style - outputs depend only on current state)
  assign disc = (current_state == S6) && (next_state == S0) && !in;
  assign flag = (current_state == S6) && (next_state == S0) && !in;
  assign err = (current_state == S7);

endmodule