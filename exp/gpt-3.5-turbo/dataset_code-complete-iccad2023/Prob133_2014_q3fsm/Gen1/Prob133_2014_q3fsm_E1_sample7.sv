module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  reg [1:0] state;
  reg [2:0] w_count;

  always @ (posedge clk) begin
    if (reset) begin
      state <= 2'b00; // Reset state A
      w_count <= 3'b000;
      z <= 0;
    end else begin
      case (state)
        2'b00: begin // State A
          if (s == 1) begin
            state <= 2'b01; // Transition to state B
          end else begin
            state <= 2'b00; // Stay in state A
          end
        end
        2'b01: begin // State B
          w_count <= {w_count[1:0], w}; // Shift in new value of w
          if (w_count[0] & !w_count[2] | !w_count[0] & w_count[2]) begin
            state <= 2'b10; // Transition to state C if exactly 2 'w's
          end else begin
            state <= 2'b01; // Stay in state B
          end
        end
        2'b10: begin // State C
          z <= 1; // Set output z to 1
          state <= 2'b00; // Transition back to state A
        end
      endcase
    end
  end

endmodule