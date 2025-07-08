module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // State encoding
  typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
  } state_t;

  state_t current_state, next_state;

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset)
      current_state <= A;
    else
      current_state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      A: next_state = (in == 0) ? A : B;
      B: next_state = (in == 0) ? C : B;
      C: next_state = (in == 0) ? A : D;
      D: next_state = (in == 0) ? C : B;
      default: next_state = A; // default fallback
    endcase
  end

  // Output logic (Moore: depends on current state only)
  always @(*) begin
    case (current_state)
      D: out = 1'b1;
      default: out = 1'b0;
    endcase
  end

endmodule