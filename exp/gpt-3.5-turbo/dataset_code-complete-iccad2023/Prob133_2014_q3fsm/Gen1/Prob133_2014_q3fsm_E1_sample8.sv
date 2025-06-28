module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  reg [1:0] state;
  reg [2:0] w_history;

  always @ (posedge clk) begin
    if (reset) begin
      state <= 2'b00; // Reset state A
      w_history <= 3'b000;
      z <= 0;
    end else begin
      case (state)
        2'b00: begin // State A
          if (s == 1) begin
            state <= 2'b01; // Transition to state B
          end
        end
        2'b01: begin // State B
          w_history <= {w, w_history[2:1]}; // Shift in new value of w
          if ((w_history[0] & w_history[1] & !w_history[2]) | (!w_history[0] & w_history[1] & w_history[2]) | (w_history[0] & !w_history[1] & w_history[2])) begin
            state <= 2'b10; // Transition to state C
            z <= 1; // Set output z to 1
          end else begin
            state <= 2'b00; // Transition back to state A
            z <= 0; // Set output z to 0
          end
        end
        2'b10: begin // State C
          state <= 2'b00; // Transition back to state A
          z <= 0; // Reset output z to 0
        end
      endcase
    end
  end

endmodule