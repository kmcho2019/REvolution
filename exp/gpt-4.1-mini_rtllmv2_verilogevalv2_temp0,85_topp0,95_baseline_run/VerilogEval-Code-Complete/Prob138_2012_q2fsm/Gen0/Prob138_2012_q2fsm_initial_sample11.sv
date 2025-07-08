module TopModule (
  input clk,
  input reset,
  input w,
  output z
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

  state_t state, next_state;

  // State register with synchronous active-high reset
  always @(posedge clk) begin
    if (reset)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      A: next_state = (w == 1'b1) ? B : A;
      B: next_state = (w == 1'b1) ? C : D;
      C: next_state = (w == 1'b1) ? E : D;
      D: next_state = (w == 1'b1) ? F : A;
      E: next_state = (w == 1'b1) ? E : D;
      F: next_state = (w == 1'b1) ? C : D;
      default: next_state = A; // safe default
    endcase
  end

  // Output logic (Moore): z=1 for states E and F, else 0
  assign z = (state == E) || (state == F);

endmodule