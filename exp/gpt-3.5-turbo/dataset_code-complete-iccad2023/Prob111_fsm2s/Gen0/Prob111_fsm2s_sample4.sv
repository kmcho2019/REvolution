module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // State encoding
  parameter OFF = 2'b00;
  parameter ON = 2'b01;

  // State register
  reg [1:0] state, next_state;

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
          out <= 1'b0;
        end
        ON: begin
          next_state = k ? OFF : ON;
          out <= 1'b1;
        end
      endcase
    end
  end

endmodule