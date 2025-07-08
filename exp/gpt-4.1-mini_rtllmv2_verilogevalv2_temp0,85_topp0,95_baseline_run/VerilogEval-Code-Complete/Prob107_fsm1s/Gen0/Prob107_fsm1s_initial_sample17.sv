module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // State encoding
  typedef enum logic {A, B} state_t;
  state_t current_state, next_state;

  // Next state logic
  always @(*) begin
    case (current_state)
      B: next_state = (in == 0) ? A : B;
      A: next_state = (in == 0) ? B : A;
      default: next_state = B;
    endcase
  end

  // State register with synchronous active-high reset
  always @(posedge clk) begin
    if (reset)
      current_state <= B;
    else
      current_state <= next_state;
  end

  // Output logic (Moore output depends only on state)
  always @(*) begin
    case (current_state)
      B: out = 1;
      A: out = 0;
      default: out = 1;
    endcase
  end

endmodule