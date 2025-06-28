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

  // State registers
  reg [1:0] state, next_state;
  reg next_out;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= OFF;
    end else begin
      state <= next_state;
    end
  end

  // Output logic
  always @* begin
    case(state)
      OFF: begin
        next_state = j ? ON : OFF;
        next_out = 1'b0;
      end
      ON: begin
        next_state = k ? OFF : ON;
        next_out = 1'b1;
      end
    endcase
  end

  // Synchronize the next state and output
  always @(posedge clk) begin
    out <= next_out;
  end

endmodule