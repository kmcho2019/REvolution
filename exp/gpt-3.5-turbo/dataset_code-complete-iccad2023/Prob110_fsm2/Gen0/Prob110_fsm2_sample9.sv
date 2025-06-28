module TopModule (
  input clk,
  input j,
  input k,
  input areset,
  output reg out
);

  // Define states
  reg [1:0] state, next_state;

  // State encoding
  parameter OFF = 2'b00;
  parameter ON  = 2'b01;

  // Moore state machine logic
  always @*
    begin
      // Default settings
      out = 1'b0;
      next_state = state;
      
      // State transitions and outputs
      case(state)
        OFF: begin
          next_state = (j) ? ON : OFF;
          out = (j) ? 1'b1 : 1'b0;
        end
        ON: begin
          next_state = (k) ? OFF : ON;
          out = (k) ? 1'b0 : 1'b1;
        end
      endcase
    end

  // Sequential state update
  always @(posedge clk or posedge areset)
    begin
      if (areset)
        state <= OFF;
      else
        state <= next_state;
    end

endmodule