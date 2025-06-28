module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // Define states
  parameter OFF = 1'b0;
  parameter ON = 1'b1;

  // State register
  reg state, next_state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= OFF;
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case (state)
      OFF: begin
        next_state = j ? ON : OFF;
        out = OFF;
      end
      ON: begin
        next_state = k ? OFF : ON;
        out = ON;
      end
    endcase
  end

endmodule