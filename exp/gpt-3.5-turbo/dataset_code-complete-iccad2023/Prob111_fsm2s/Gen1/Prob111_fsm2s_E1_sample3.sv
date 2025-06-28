module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // Define states
  parameter OFF = 2'b00;
  parameter ON = 2'b01;

  // State register
  reg [1:0] state, next_state;

  always @(posedge clk) begin
    if (reset)
      state <= OFF;
    else
      state <= next_state;
  end

  always @* begin
    case(state)
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

endmodule