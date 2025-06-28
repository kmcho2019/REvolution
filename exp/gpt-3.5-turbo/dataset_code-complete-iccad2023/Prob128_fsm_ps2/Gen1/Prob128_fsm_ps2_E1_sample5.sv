module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter SHIFT = 2'b00;
parameter LOAD = 2'b01;
parameter EVALUATE = 2'b10;

// Define state register
reg [1:0] state, next_state;

// Define data register
reg [7:0] data_reg;

// Synchronous reset
always @(posedge clk) begin
  if (reset)
    state <= SHIFT;
  else
    state <= next_state;
end

// Next state logic and output
always @* begin
  // Default next state
  next_state = state;
  done = 0;

  case(state)
    SHIFT: begin
      if (in[3] == 1)
        next_state = LOAD;
    end
    LOAD: begin
      data_reg <= in;
      next_state = EVALUATE;
    end
    EVALUATE: begin
      if (data_reg[3] == 1 && in[3] == 0)
        done = 1;
      next_state = SHIFT;
    end
    default: begin
      next_state = SHIFT;
    end
  endcase
end

endmodule