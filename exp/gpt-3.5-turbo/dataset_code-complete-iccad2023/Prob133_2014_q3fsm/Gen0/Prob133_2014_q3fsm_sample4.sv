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
      z <= 1'b0;
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
            z <= 1'b1;
          end
          next_state <= STATE_B;
        end
      endcase
    end
  end
endmodule