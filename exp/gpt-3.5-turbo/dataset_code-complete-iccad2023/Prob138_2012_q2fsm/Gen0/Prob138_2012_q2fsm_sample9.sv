module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

// Define state codes
typedef enum logic [3:0] {
  A, B, C, D, E, F
} state_type;

// State flip-flops
reg [3:0] current_state, next_state;

// State transition logic
always @(current_state, w)
begin
  next_state = current_state;
  case(current_state)
    A: next_state = (w) ? B : A;
    B: next_state = (w) ? C : D;
    C: next_state = (w) ? E : D;
    D: next_state = (w) ? F : A;
    E: next_state = (w) ? E : D;
    F: next_state = (w) ? C : D;
  endcase
end

// Synchronous reset
always @(posedge clk)
begin
  if (reset)
    current_state <= A;
  else
    current_state <= next_state;
end

// Output assignment based on current state
always @(*)
begin
  case(current_state)
    A: z = 0;
    B: z = 0;
    C: z = 0;
    D: z = 0;
    E: z = 1;
    F: z = 1;
  endcase
end

endmodule