module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  reg [1:0] state, next_state;
  reg [2:0] w_count;

  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00; // State A
      w_count <= 3'b0;
      z <= 0;
    end else begin
      state <= next_state;
      case(state)
        2'b00: begin // State A
          if (s == 1) begin
            next_state = 2'b01; // Transition to State B
          end else begin
            next_state = 2'b00; // Stay in State A
          end
        end
        2'b01: begin // State B
          if (w == 1) begin
            w_count <= w_count + 1;
          end
          if (w_count == 3) begin
            if (w_count == 2) begin
              z <= 1;
            end else begin
              z <= 0;
            end
            w_count <= 0; // Reset w_count for the next cycle
          end
          next_state = 2'b01; // Stay in State B
        end
      endcase
    end
  end

endmodule