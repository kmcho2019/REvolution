module TopModule (
  input  clk,
  input  areset,
  input  in,
  output out
);

// Define the states
enum logic [0:0] {A, B} state, next_state;

// Output logic
assign out = (state == B) ? 1'b1 : 1'b0;

// Next state logic
always_comb begin
  case (state)
    A: begin
      if (in == 1'b1)
        next_state = A;
      else
        next_state = B;
    end
    B: begin
      if (in == 1'b1)
        next_state = B;
      else
        next_state = A;
    end
    default: next_state = B;
  endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
  if (areset)
    state <= B;
  else
    state <= next_state;
end

endmodule