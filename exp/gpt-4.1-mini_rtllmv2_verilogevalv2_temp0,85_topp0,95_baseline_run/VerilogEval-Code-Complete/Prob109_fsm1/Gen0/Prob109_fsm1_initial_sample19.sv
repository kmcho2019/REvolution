module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  // State encoding
  typedef enum logic {
    B = 1'b1,
    A = 1'b0
  } state_t;

  state_t state, next_state;

  // State register with asynchronous reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset)
      state <= B;
    else
      state <= next_state;
  end

  // Next state logic
  always_comb begin
    case(state)
      B: next_state = (in == 1'b0) ? A : B;
      A: next_state = (in == 1'b0) ? B : A;
      default: next_state = B;
    endcase
  end

  // Output logic (Moore machine: output depends only on state)
  always_comb begin
    case(state)
      B: out = 1'b1;
      A: out = 1'b0;
      default: out = 1'b1;
    endcase
  end

endmodule