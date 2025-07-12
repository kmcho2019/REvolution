module TopModule(
  input  clk,
  input  areset,
  input  in,
  output out
);

// Define the states as an enumeration
enum logic [1:0] {
  A,
  B,
  C,
  D
} state, next_state;

// Combinational logic to determine the next state and output
always_comb begin
  case(state)
    A: next_state = (in == 0) ? A : B;
    B: next_state = (in == 0) ? C : B;
    C: next_state = (in == 0) ? A : D;
    D: next_state = (in == 0) ? C : B;
  endcase
  out = (state == D) ? 1'b1 : 1'b0;
end

// Sequential logic to update the current state
always_ff @(posedge clk or posedge areset) begin
  if(areset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

endmodule