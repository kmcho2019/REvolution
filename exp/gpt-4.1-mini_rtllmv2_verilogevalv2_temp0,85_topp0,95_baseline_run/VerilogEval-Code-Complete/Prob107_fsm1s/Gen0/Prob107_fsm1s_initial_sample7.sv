module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // State encoding
  typedef enum reg {A = 1'b0, B = 1'b1} state_t;
  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case (state)
      B: next_state = (in == 1'b0) ? A : B;
      A: next_state = (in == 1'b0) ? B : A;
      default: next_state = B; // Default to reset state
    endcase
  end

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset)
      state <= B;
    else
      state <= next_state;
  end

  // Output logic for Moore machine (depends on state only)
  always @(*) begin
    case (state)
      B: out = 1'b1;
      A: out = 1'b0;
      default: out = 1'b1;
    endcase
  end

endmodule