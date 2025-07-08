module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);
  // State encoding
  typedef enum reg [1:0] {
    A = 2'd0,
    B = 2'd1,
    C = 2'd2,
    D = 2'd3
  } state_t;

  state_t current_state, next_state;

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      current_state <= A;
    else
      current_state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      A: next_state = (in) ? B : A;
      B: next_state = (in) ? B : C;
      C: next_state = (in) ? D : A;
      D: next_state = (in) ? B : C;
      default: next_state = A;
    endcase
  end

  // Output logic (Moore machine: output depends only on current state)
  always @(*) begin
    out = (current_state == D) ? 1'b1 : 1'b0;
  end

endmodule