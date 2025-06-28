module TopModule (
  input clk,
  input j,
  input k,
  input areset,
  output reg out
);

  // State definitions
  parameter OFF = 1'b0;
  parameter ON = 1'b1;

  // State registers
  reg current_state, next_state;

  // Moore state machine logic
  always @(posedge clk or posedge areset)
  begin
    if (areset) begin
      current_state <= OFF;
    end
    else begin
      current_state <= next_state;
    end
  end

  // State transition and output logic
  always @*
  begin
    case (current_state)
      OFF: begin
        if (j == 0)
          next_state = OFF;
        else
          next_state = ON;
        out = 1'b0;
      end

      ON: begin
        if (k == 0)
          next_state = ON;
        else
          next_state = OFF;
        out = 1'b1;
      end
    endcase
  end

endmodule