module TopModule(
  input  clk,
  input  reset,
  input  j,
  input  k,
  output out
);

// Define states as an enum
typedef enum logic [0:0] {OFF, ON} state_t;

// Register to hold the current state
state_t current_state;
state_t next_state;

// Output logic
assign out = (current_state == ON) ? 1'b1 : 1'b0;

// Next state logic
always_comb begin
  case (current_state)
    OFF: begin
      if (j) next_state = ON;
      else next_state = OFF;
    end
    ON: begin
      if (k) next_state = OFF;
      else next_state = ON;
    end
  endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
  if (reset) current_state <= OFF;
  else current_state <= next_state;
end

endmodule