module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  reg [1:0] state;
  reg [1:0] w_count;

  always @ (posedge clk) begin
    if (reset) begin
      state <= 2'b00; // Reset state A
      w_count <= 2'b00;
      z <= 0;
    end else begin
      case (state)
        2'b00: begin // State A
          if (s == 1) begin
            state <= 2'b01; // Transition to state B
          end
        end
        2'b01: begin // State B
          w_count <= {w_count[0], w}; // Shift in new value of w
          if ((w_count[0] & !w_count[1] & w_count[2]) | (!w_count[0] & w_count[1] & w_count[2]) | (w_count[0] & w_count[1] & !w_count[2])) begin
            z <= 1; // Set output z to 1
          end else begin
            z <= 0; // Set output z to 0
          end
          state <= 2'b01; // Stay in state B
        end
      endcase
    end
  end

endmodule