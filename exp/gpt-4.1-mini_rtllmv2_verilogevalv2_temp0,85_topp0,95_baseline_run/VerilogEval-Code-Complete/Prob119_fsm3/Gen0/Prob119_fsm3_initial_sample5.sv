module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  // State encoding
  typedef enum logic [1:0] {
    A = 2'd0,
    B = 2'd1,
    C = 2'd2,
    D = 2'd3
  } state_t;

  state_t state, next_state;

  // State transition logic
  always @(*) begin
    case(state)
      A: next_state = (in == 1'b0) ? A : B;
      B: next_state = (in == 1'b0) ? C : B;
      C: next_state = (in == 1'b0) ? A : D;
      D: next_state = (in == 1'b0) ? C : B;
      default: next_state = A;
    endcase
  end

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= A;
    else
      state <= next_state;
  end

  // Output logic (Moore output)
  always @(*) begin
    case(state)
      D: out = 1'b1;
      default: out = 1'b0;
    endcase
  end

endmodule