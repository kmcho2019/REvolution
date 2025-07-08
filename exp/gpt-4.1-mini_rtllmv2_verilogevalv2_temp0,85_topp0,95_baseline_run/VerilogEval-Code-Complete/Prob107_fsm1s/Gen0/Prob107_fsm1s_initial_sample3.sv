module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // Define states
  typedef enum logic {
    B,
    A
  } state_t;

  state_t state, next_state;

  // State transition logic (combinational)
  always @(*) begin
    case (state)
      B: next_state = (in == 0) ? A : B;
      A: next_state = (in == 0) ? B : A;
      default: next_state = B;
    endcase
  end

  // State update (sequential) with synchronous active-high reset
  always @(posedge clk) begin
    if (reset)
      state <= B;
    else
      state <= next_state;
  end

  // Output logic (Moore machine, output depends on state only)
  always @(*) begin
    case (state)
      B: out = 1;
      A: out = 0;
      default: out = 1;
    endcase
  end

endmodule