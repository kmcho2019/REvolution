module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  typedef enum logic {A=0, B=1} state_t;
  state_t state, next_state;

  // Asynchronous reset and state update
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= B;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      B: next_state = (in == 0) ? A : B;
      A: next_state = (in == 0) ? B : A;
      default: next_state = B;
    endcase
  end

  // Output logic (Moore machine - output depends on state)
  always @(*) begin
    case (state)
      B: out = 1'b1;
      A: out = 1'b0;
      default: out = 1'b0;
    endcase
  end

endmodule