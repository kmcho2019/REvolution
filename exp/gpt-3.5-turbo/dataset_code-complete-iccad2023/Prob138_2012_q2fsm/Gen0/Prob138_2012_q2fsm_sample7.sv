module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

  // Define state codes
  parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
  
  reg [2:0] present_state, next_state;

  // State transition logic
  always @*
    case(present_state)
      A: next_state = w ? B : A;
      B: next_state = w ? C : D;
      C: next_state = w ? E : D;
      D: next_state = w ? F : A;
      E: next_state = w ? E : D;
      F: next_state = w ? C : D;
      default: next_state = A;
    endcase

  // State flip-flops
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      present_state <= A;
    else
      present_state <= next_state;
  end
  
  // FSM output assignment
  always @*
    case(present_state)
      E: z = 1'b1;
      default: z = 1'b0;
    endcase

endmodule