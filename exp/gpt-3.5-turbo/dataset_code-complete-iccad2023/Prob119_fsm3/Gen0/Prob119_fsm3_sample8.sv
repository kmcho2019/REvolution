module MooreStateMachine (
  input clk,
  input in,
  input areset,
  output reg out,
  output reg [1:0] state
);

// State encoding: A=2'b00, B=2'b01, C=2'b10, D=2'b11
// State transition and output logic
always @ (posedge clk or posedge areset)
begin
    if (areset)
        state <= 2'b00; // Reset state to A
    else
        case(state)
            2'b00: begin // State A
                if (in)
                    state <= 2'b10; // Next state C
                else
                    state <= 2'b01; // Next state B
                out <= 1'b0;
            end
            2'b01: begin // State B
                if (in)
                    state <= 2'b01; // Next state B
                else
                    state <= 2'b10; // Next state C
                out <= 1'b0;
            end
            2'b10: begin // State C
                if (in)
                    state <= 2'b00; // Next state A
                else
                    state <= 2'b11; // Next state D
                out <= 1'b0;
            end
            2'b11: begin // State D
                if (in)
                    state <= 2'b10; // Next state C
                else
                    state <= 2'b01; // Next state B
                out <= 1'b1;
            end
        endcase
end

endmodule

module TopModule (
  input clk,
  input in,
  input areset,
  output out
);

reg [1:0] state;

MooreStateMachine fsm (
  .clk(clk),
  .in(in),
  .areset(areset),
  .out(out),
  .state(state)
);

endmodule