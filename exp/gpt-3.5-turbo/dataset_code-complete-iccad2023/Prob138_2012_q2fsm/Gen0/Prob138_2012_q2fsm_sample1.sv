module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

  // State encoding
  parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

  // Registers for state and next state
  reg [2:0] state, next_state;

  // Output z assignment
  always @*
    case (state)
      A: z = 1'b0;
      default: z = 1'b1;
    endcase

  // State transition logic
  always @* begin
    next_state = state;
    case (state)
      A: next_state = (w) ? B : A;
      B: next_state = (w) ? C : D;
      C: next_state = (w) ? E : D;
      D: next_state = (w) ? F : A;
      E: next_state = (w) ? E : D;
      F: next_state = (w) ? C : D;
    endcase
  end

  // Sequential logic for state update
  always @(posedge clk or posedge reset) begin
    if (reset)
      state <= A;
    else
      state <= next_state;
  end

endmodule