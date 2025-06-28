module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// State definition
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
reg [1:0] state, next_state;

always @ (posedge clk or posedge reset)
begin
  if (reset) // synchronous reset
    state <= S0;
  else
    state <= next_state;
end

always @*
begin
  // Default next state
  next_state = state;

  case (state)
    S0: if (data) next_state = S1; // Looking for '1'
    S1: if (data) next_state = S2; // Looking for '1'
        else next_state = S0;
    S2: if (data) next_state = S3; // Looking for '0'
        else next_state = S0; // Reset if '0' not found in sequence
    S3: if (data) start_shifting = 1; // Sequence found, start shifting
        next_state = S0; // Reset state machine
  endcase
end

endmodule