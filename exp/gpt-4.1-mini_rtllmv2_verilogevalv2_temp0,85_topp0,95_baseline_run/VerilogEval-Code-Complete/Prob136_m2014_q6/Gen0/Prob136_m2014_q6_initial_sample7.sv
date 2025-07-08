module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

  // State encoding
  typedef enum logic [2:0] {
    A = 3'd0,
    B = 3'd1,
    C = 3'd2,
    D = 3'd3,
    E = 3'd4,
    F = 3'd5
  } state_t;

  state_t current_state, next_state;

  // State register
  always @(posedge clk) begin
    if (reset)
      current_state <= A;
    else
      current_state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      A: next_state = (w == 1'b0) ? B : A;
      B: next_state = (w == 1'b0) ? C : D;
      C: next_state = (w == 1'b0) ? E : D;
      D: next_state = (w == 1'b0) ? F : A;
      E: next_state = (w == 1'b0) ? E : D;
      F: next_state = (w == 1'b0) ? C : D;
      default: next_state = A;
    endcase
  end

  // Output logic (Moore machine)
  always @(*) begin
    z = (current_state == E) ? 1'b1 : 1'b0;
  end

endmodule