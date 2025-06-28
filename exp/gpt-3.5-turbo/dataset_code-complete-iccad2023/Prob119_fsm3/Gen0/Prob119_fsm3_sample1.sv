module MooreStateMachine (
  input clk,
  input in,
  input areset,
  output reg out
);

  // State encoding: A=2'b00, B=2'b01, C=2'b10, D=2'b11
  reg [1:0] state, next_state;

  // State transition and output logic
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00; // Reset to state A
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case(state)
      2'b00: begin // State A
        next_state = (in) ? 2'b01 : 2'b10;
        out = 1'b0;
      end
      2'b01: begin // State B
        next_state = (in) ? 2'b01 : 2'b10;
        out = 1'b0;
      end
      2'b10: begin // State C
        next_state = (in) ? 2'b10 : 2'b11;
        out = 1'b0;
      end
      2'b11: begin // State D
        next_state = (in) ? 2'b01 : 2'b10;
        out = 1'b1;
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

  MooreStateMachine fsm (
    .clk(clk),
    .in(in),
    .areset(areset),
    .out(out)
  );

endmodule