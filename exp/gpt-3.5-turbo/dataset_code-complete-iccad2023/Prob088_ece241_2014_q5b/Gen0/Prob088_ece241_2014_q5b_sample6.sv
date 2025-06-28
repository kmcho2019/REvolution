module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states using one-hot encoding
parameter A = 2'b01;
parameter B = 2'b10;

// Define state register
reg [1:0] state, next_state;

// Asynchronous reset
always @(posedge clk or posedge areset)
begin
  if (areset)
    state <= A;
  else
    state <= next_state;
end

// Next state logic and output assignment
always @(*)
begin
  case(state)
    A: begin
      if (x)
        next_state = B;
      else
        next_state = A;
      z = 0;
    end
    B: begin
      if (x)
        next_state = B;
      else
        next_state = B;
      z = 1;
    end
  endcase
end

endmodule