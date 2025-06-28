module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  reg state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= 1'b1; // Initial state B
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case(state)
      1'b0: begin // State A
        out = 1'b0;
        next_state = in ? 1'b0 : 1'b1; // State transitions based on input
      end
      1'b1: begin // State B
        out = 1'b1;
        next_state = in ? 1'b1 : 1'b0; // State transitions based on input
      end
    endcase
  end

endmodule