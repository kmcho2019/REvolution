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
  reg prev_w;

  always @ (posedge clk or posedge reset)
  begin
    if (reset) begin
      state_reg <= STATE_A;
      z <= 1'b0;
    end
    else begin
      state_reg <= next_state;
      prev_w <= w;
      case (state_reg)
        STATE_A: begin
          if (s) begin
            next_state <= STATE_B;
          end
          else begin
            next_state <= STATE_A;
          end
        end
        STATE_B: begin
          if (w && !prev_w) begin
            if (z == 1'b0)
              z <= 1'b1;
            else
              z <= 1'b0;
          end
          next_state <= STATE_B;
        end
      endcase
    end
  end
endmodule