module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  reg [1:0] state, next_state;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00; // Reset to state A
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case (state)
      2'b00: begin // State A
        if (in)
          next_state = 2'b01; // Transition to B
        else
          next_state = 2'b00; // Transition to A
        out = 1'b0;
      end
      2'b01: begin // State B
        if (in)
          next_state = 2'b01; // Stay at B
        else
          next_state = 2'b10; // Transition to C
        out = 1'b0;
      end
      2'b10: begin // State C
        if (in)
          next_state = 2'b11; // Transition to D
        else
          next_state = 2'b00; // Transition to A
        out = 1'b0;
      end
      2'b11: begin // State D
        if (in)
          next_state = 2'b01; // Transition to B
        else
          next_state = 2'b10; // Transition to C
        out = 1'b1;
      end
    endcase
  end

endmodule