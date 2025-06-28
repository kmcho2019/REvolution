module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // Define state enum
  typedef enum logic [1:0] {
    STATE_A,
    STATE_B
  } state_t;

  // Define state register
  reg [1:0] state_reg, next_state;

  // Define counter to track number of w = 1 cycles
  reg [1:0] w_count;

  always @ (posedge clk or posedge reset)
  begin
    if (reset) begin
      state_reg <= STATE_A;
      w_count <= 2'b0;
      z <= 1'b0; // Set z to 0 on reset
    end
    else begin
      state_reg <= next_state;
      case (state_reg)
        STATE_A: begin
          if (s) begin
            next_state <= STATE_B;
            w_count <= 2'b0;
          end
          else begin
            next_state <= STATE_A;
          end
        end
        STATE_B: begin
          if (w) begin
            w_count <= w_count + 1;
          end
          if (w_count == 2) begin
            z <= 1'b1; // Set z to 1 after w is high for 2 cycles
          end
          else begin
            z <= 1'b0; // Set z to 0 when w is not high for 2 cycles
          end
          if (!w) begin
            next_state <= STATE_A; // Transition back to State_A if w is low
          end
          else begin
            next_state <= STATE_B; // Stay in State_B for tracking w_count
          end
        end
      endcase
    end
  end

endmodule