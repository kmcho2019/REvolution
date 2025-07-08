module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  typedef enum logic {A, B} state_t;
  state_t state, next_state;

  // State transition logic
  always @(*) begin
    case (state)
      B: next_state = in ? B : A;
      A: next_state = in ? A : B;
      default: next_state = B;
    endcase
  end

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= B;
    else
      state <= next_state;
  end

  // Output logic (Moore): output depends only on state
  always @(*) begin
    case (state)
      B: out = 1'b1;
      A: out = 1'b0;
      default: out = 1'b0;
    endcase
  end

endmodule