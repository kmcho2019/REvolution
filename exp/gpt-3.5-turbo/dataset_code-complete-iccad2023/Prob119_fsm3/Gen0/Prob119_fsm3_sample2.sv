module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  // Define states
  reg [1:0] state, next_state;

  // State transition and output logic
  always @ (posedge clk or posedge areset)
    if (areset)
      state <= 2'b00; // Reset to state A
    else
      state <= next_state;

  always @*
    case (state)
      2'b00: begin // State A
        if (in)
          next_state = 2'b10; // Next state D
        else
          next_state = 2'b01; // Next state B
        out = 1'b0;
      end
      2'b01: begin // State B
        if (in)
          next_state = 2'b10; // Next state C
        else
          next_state = 2'b01; // Next state B
        out = 1'b0;
      end
      2'b10: begin // State C
        if (in)
          next_state = 2'b11; // Next state D
        else
          next_state = 2'b00; // Next state A
        out = 1'b0;
      end
      2'b11: begin // State D
        if (in)
          next_state = 2'b10; // Next state C
        else
          next_state = 2'b01; // Next state B
        out = 1'b1;
      end
      default: begin
        next_state = 2'b00; // Default state A
        out = 1'b0; // Default output
      end
    endcase

endmodule