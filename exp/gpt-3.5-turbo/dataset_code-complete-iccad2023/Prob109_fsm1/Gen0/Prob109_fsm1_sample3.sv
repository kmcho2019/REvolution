module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

// State encoding
parameter A = 0;
parameter B = 1;

// State register
reg [1:0] state, next_state;

// Next state logic
always @*
begin
  case(state)
    A: next_state = (areset) ? B : (in) ? A : B;
    B: next_state = (areset) ? B : (in) ? B : A;
  endcase
end

// State transition
always @(posedge clk or posedge areset)
begin
  if (areset)
    state <= B;
  else
    state <= next_state;
end

// Output logic
always @*
begin
  out = (state == A);
end

endmodule