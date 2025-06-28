module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

  // State codes
  parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
  reg [2:0] state, next_state;

  // State table
  always @*
    begin
      case(state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
      endcase
    end

  // State flip-flop
  always @(posedge clk or posedge reset)
    begin
      if (reset)
        state <= A;
      else
        state <= next_state;
    end

  // Output assignment
  always @*
    begin
      case(state)
        E: z = 1;
        default: z = 0;
      endcase
    end

endmodule