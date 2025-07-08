module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

  typedef enum logic [2:0] {
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4
  } state_t;

  state_t current_state, next_state;

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset)
      current_state <= S0;
    else
      current_state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      S0: next_state = (data) ? S1 : S0;
      S1: next_state = (data) ? S2 : S0;
      S2: next_state = (data) ? S2 : S3;
      S3: next_state = (data) ? S4 : S0;
      S4: next_state = S4;
      default: next_state = S0;
    endcase
  end

  // Output logic: start_shifting = 1 in S4 forever until reset
  always @(posedge clk) begin
    if (reset)
      start_shifting <= 1'b0;
    else if (current_state == S4)
      start_shifting <= 1'b1;
  end

endmodule