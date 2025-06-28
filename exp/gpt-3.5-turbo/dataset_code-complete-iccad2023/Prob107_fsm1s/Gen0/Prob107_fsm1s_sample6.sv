module MooreStateMachine (
  input clk,
  input in,
  input reset,
  output reg out
);

  // State encoding: B=0, A=1
  reg [1:0] state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00; // Initialize in reset state B
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case(state)
      2'b00: begin // State B
        if (in) begin
          next_state = 2'b00; // B on input 1
        end else begin
          next_state = 2'b01; // A on input 0
        end
        out = 1; // Output is always 1 in state B
      end

      2'b01: begin // State A
        if (in) begin
          next_state = 2'b01; // A on input 1
        end else begin
          next_state = 2'b00; // B on input 0
        end
        out = 0; // Output is always 0 in state A
      end
    endcase
  end

endmodule