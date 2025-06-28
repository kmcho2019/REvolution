module MooreStateMachine (
  input clk,
  input j,
  input k,
  input areset,
  output reg out
);

  // State encoding: 0 -> OFF, 1 -> ON
  reg [1:0] state, next_state;

  // State transition and output logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00; // OFF state
    end
    else begin
      state <= next_state;
    end
  end

  always @* begin
    case (state)
      2'b00: begin // OFF state
        if (j) next_state = 2'b01; // Transition to ON state
        else next_state = 2'b00;  // Stay in OFF state
        out = 1'b0; // Output is 0
      end
      2'b01: begin // ON state
        if (k) next_state = 2'b00; // Transition to OFF state
        else next_state = 2'b01;  // Stay in ON state
        out = 1'b1; // Output is 1
      end
      default: next_state = 2'b00;
    endcase
  end

endmodule