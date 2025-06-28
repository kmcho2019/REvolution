module MooreStateMachine (
  input clk,
  input in,
  input reset,
  output reg out
);

// Enum for states
typedef enum logic [1:0] {B, A} state_type;

// State variables
reg [1:0] state, next_state;

// State register
always @(posedge clk) begin
  if (reset)
    state <= B;
  else
    state <= next_state;
end

// Next state logic
always @(*) begin
  case (state)
    B: begin
      if (in)
        next_state = B;
      else
        next_state = A;
    end
    A: begin
      if (in)
        next_state = A;
      else
        next_state = B;
    end
  endcase
end

// Output logic
always @(*) begin
  if (state == B)
    out = 1;
  else
    out = 0;
end

endmodule