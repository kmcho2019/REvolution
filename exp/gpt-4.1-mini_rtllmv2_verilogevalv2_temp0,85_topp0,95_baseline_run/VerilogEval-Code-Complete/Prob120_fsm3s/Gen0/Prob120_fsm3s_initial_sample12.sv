module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // State encoding
  typedef enum reg [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
  } state_t;

  state_t current_state, next_state;

  // Next state logic
  always @(*) begin
    case (current_state)
      A: next_state = (in == 1'b0) ? A : B;
      B: next_state = (in == 1'b0) ? C : B;
      C: next_state = (in == 1'b0) ? A : D;
      D: next_state = (in == 1'b0) ? C : B;
      default: next_state = A;
    endcase
  end

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset)
      current_state <= A;
    else
      current_state <= next_state;
  end

  // Output logic (Moore)
  always @(*) begin
    out = (current_state == D) ? 1'b1 : 1'b0;
  end

endmodule