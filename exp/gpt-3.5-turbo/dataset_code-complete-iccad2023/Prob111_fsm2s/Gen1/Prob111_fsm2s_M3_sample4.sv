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

  // State transition and output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= OFF;
      out <= 1'b0;
    end else begin
      state <= next_state;
      case (state)
        OFF: begin
          next_state = j ? ON : OFF;
          out = 1'b0;
        end
        ON: begin
          next_state = k ? OFF : ON;
          out = 1'b1;
        end
      endcase
    end
  end

endmodule