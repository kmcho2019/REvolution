module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  typedef enum logic {A, B} state_t;
  state_t state, next_state;

  // State transition logic
  always @(*) begin
    case (state)
      B: next_state = (in == 0) ? A : B;
      A: next_state = (in == 0) ? B : A;
      default: next_state = B;
    endcase
  end

  // State register with synchronous active-high reset
  always @(posedge clk) begin
    if (reset)
      state <= B;
    else
      state <= next_state;
  end

  // Output logic (Moore machine)
  always @(*) begin
    case (state)
      B: out = 1;
      A: out = 0;
      default: out = 1;
    endcase
  end

endmodule