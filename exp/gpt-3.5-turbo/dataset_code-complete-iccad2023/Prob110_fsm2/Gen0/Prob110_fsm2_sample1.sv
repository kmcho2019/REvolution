module MooreStateMachine (
  input clk,
  input j,
  input k,
  input areset,
  output reg out
);

  // Define the states
  parameter OFF = 2'b00;
  parameter ON  = 2'b01;

  // Define a register to hold the current state
  reg [1:0] state, next_state;

  // Next state logic
  always @(*) begin
    case(state)
      OFF: begin
        if (j) next_state = ON;
        else next_state = OFF;
      end
      ON: begin
        if (k) next_state = OFF;
        else next_state = ON;
      end
      default: next_state = OFF;
    endcase
  end

  // State transition and output logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= OFF;
      out <= 0;
    end
    else begin
      state <= next_state;
      case(next_state)
        OFF: out <= 0;
        ON: out <= 1;
      endcase
    end
  end

endmodule