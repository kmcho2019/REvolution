module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // One-hot encoding for states
  reg [1:0] state;
  parameter OFF = 2'b01;
  parameter ON = 2'b10;

  // Mealy state machine transitions and output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= OFF;
      out <= 1'b0;
    end else begin
      case (state)
        OFF: begin
          if (j)
            state <= ON;
          else
            state <= OFF;
          out <= 1'b0;
        end
        ON: begin
          if (k)
            state <= OFF;
          else
            state <= ON;
          out <= 1'b1;
        end
      endcase
    end
  end

endmodule