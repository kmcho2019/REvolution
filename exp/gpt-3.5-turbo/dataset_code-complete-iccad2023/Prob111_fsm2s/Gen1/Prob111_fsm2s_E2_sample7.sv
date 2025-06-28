module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // State encoding
  parameter OFF = 1'b0;
  parameter ON = 1'b1;

  // State register
  reg state, next_state;

  // State transition logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= OFF;
    end else begin
      state <= next_state;
    end
  end
  
  // Next state logic
  always @* begin
    case (state)
      OFF: begin
        next_state = j ? ON : OFF;
      end
      ON: begin
        next_state = k ? OFF : ON;
      end
    endcase
  end

  // Output assignment based on current state
  always @* begin
    case (state)
      OFF: out = 1'b0;
      ON: out = 1'b1;
    endcase
  end

endmodule