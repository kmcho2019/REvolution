module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

// State encoding: A=0, B=1, C=2, D=3, E=4, F=5
reg [2:0] state, next_state;

always @(posedge clk or posedge reset)
begin
  if (reset)
    state <= 3'b000; // Initialize to state A
  else
    state <= next_state;
end

always @*
begin
  case (state)
    3'b000: // State A
      begin
        if (w)
          next_state = 3'b001; // Transition to B on w=1
        else
          next_state = 3'b000; // Stay in A on w=0
      end
    3'b001: // State B
      begin
        if (w)
          next_state = 3'b010; // Transition to C on w=1
        else
          next_state = 3'b011; // Transition to D on w=0
      end
    3'b010: // State C
      begin
        if (w)
          next_state = 3'b100; // Transition to E on w=1
        else
          next_state = 3'b011; // Transition to D on w=0
      end
    3'b011: // State D
      begin
        if (w)
          next_state = 3'b101; // Transition to F on w=1
        else
          next_state = 3'b000; // Transition to A on w=0
      end
    3'b100: // State E
      begin
        if (w)
          next_state = 3'b100; // Stay in E on w=1
        else
          next_state = 3'b011; // Transition to D on w=0
      end
    3'b101: // State F
      begin
        if (w)
          next_state = 3'b010; // Transition to C on w=1
        else
          next_state = 3'b011; // Transition to D on w=0
      end
    default:
      next_state = 3'b000; // Default to A
  endcase
end

always @*
begin
  case (state)
    3'b100: z = 1; // Output z = 1 in state E
    default: z = 0; // Output z = 0 in all other states
  endcase
end

endmodule