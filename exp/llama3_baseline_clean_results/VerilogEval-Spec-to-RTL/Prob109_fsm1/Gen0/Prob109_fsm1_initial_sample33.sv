module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Enum for states
enum logic [0:0] {A, B} state, next_state;

// Assign output based on state
assign out = (state == A) ? 0 : 1;

// State transition logic
always_comb begin
  case(state)
    A: begin
      if (in == 0) next_state = B;
      else next_state = A;
    end
    B: begin
      if (in == 0) next_state = A;
      else next_state = B;
    end
    default: next_state = B; // default to state B
  endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
  if (areset) state <= B;
  else state <= next_state;
end

endmodule