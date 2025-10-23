module TopModule(
  input  clk,
  input  areset,
  input  j,
  input  k,
  output out
);

// Define the states
enum logic [0:0] {OFF, ON} state, next_state;

// Combinational logic for next state and output
always_comb begin
  case (state)
    OFF: begin
      if (j) next_state = ON;
      else  next_state = OFF;
      out = 0;
    end
    ON: begin
      if (k) next_state = OFF;
      else  next_state = ON;
      out = 1;
    end
    default: begin
      next_state = OFF;
      out = 0;
    end
  endcase
end

// Sequential logic for state update
always_ff @(posedge clk or posedge areset) begin
  if (areset) state <= OFF;
  else        state <= next_state;
end

endmodule