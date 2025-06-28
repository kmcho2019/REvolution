module MooreFSM (
  input clk,
  input in,
  input areset,
  output reg out
);

  // State declaration
  reg [1:0] state, next_state;
  
  // State transition and output logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00;  // Reset to state A
    end else begin
      state <= next_state;
    end
  end
  
  always @(*) begin
    case (state)
      2'b00: begin  // State A
        if (in)
          next_state = 2'b01; // Transition to B for in=1
        else
          next_state = 2'b00; // Stay at A for in=0
        out = 1'b0;
      end
      2'b01: begin  // State B
        if (in)
          next_state = 2'b01; // Stay at B for in=1
        else
          next_state = 2'b10; // Transition to C for in=0
        out = 1'b0;
      end
      2'b10: begin  // State C
        if (in)
          next_state = 2'b11; // Transition to D for in=1
        else
          next_state = 2'b00; // Transition to A for in=0
        out = 1'b0;
      end
      2'b11: begin  // State D
        if (in)
          next_state = 2'b01; // Transition to B for in=1
        else
          next_state = 2'b10; // Stay at D for in=0
        out = 1'b1;
      end
      default: begin
        next_state = 2'b00; // Default state A in case of unknown state
        out = 1'b0;         // Default output
      end
    endcase
  end

endmodule