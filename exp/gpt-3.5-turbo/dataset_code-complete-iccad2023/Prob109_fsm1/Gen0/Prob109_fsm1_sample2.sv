module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

// Define states
parameter A = 1'b0;
parameter B = 1'b1;

// State registers
reg current_state, next_state;

// Next state logic
always @(*)
begin
  case(current_state)
    A: begin
      if(in) next_state = A;
      else next_state = B;
    end
    B: begin
      if(in) next_state = B;
      else next_state = A;
    end
  endcase
end

// State transition and output
always @(posedge clk or posedge areset)
begin
  if(areset)
    current_state <= B;
  else
    current_state <= next_state;
  
  out <= current_state;
end

endmodule