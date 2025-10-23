module TopModule(
  input clk,
  input reset,
  input j,
  input k,
  output out
);

reg [0:0] state; // Current state
reg [0:0] next_state; // Next state

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Determine the next state
always @(*) begin
  case(state)
    OFF: begin
      if(j) next_state = ON;
      else next_state = OFF;
    end
    ON: begin
      if(k) next_state = OFF;
      else next_state = ON;
    end
  endcase
end

// Update the current state on every clock cycle
always @(posedge clk) begin
  if(reset) state <= OFF;
  else state <= next_state;
end

// Determine the output
assign out = state;

endmodule