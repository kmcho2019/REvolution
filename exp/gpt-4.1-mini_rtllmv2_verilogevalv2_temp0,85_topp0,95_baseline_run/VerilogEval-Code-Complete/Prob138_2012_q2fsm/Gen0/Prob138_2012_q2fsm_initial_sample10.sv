module TopModule (
  input clk,
  input reset,
  input w,
  output z
);

  // State encoding
  localparam A = 3'b000;
  localparam B = 3'b001;
  localparam C = 3'b010;
  localparam D = 3'b011;
  localparam E = 3'b100;
  localparam F = 3'b101;

  reg [2:0] state, next_state;

  // State flip-flops with synchronous active-high reset
  always @(posedge clk) begin
    if (reset)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic (state table)
  always @(*) begin
    case(state)
      A: next_state = (w == 1'b1) ? B : A;
      B: next_state = (w == 1'b1) ? C : D;
      C: next_state = (w == 1'b1) ? E : D;
      D: next_state = (w == 1'b1) ? F : A;
      E: next_state = (w == 1'b1) ? E : D;
      F: next_state = (w == 1'b1) ? C : D;
      default: next_state = A; // default safe state
    endcase
  end

  // Output logic
  // z = 1 for states E and F, 0 otherwise
  assign z = (state == E) || (state == F);

endmodule