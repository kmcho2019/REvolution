module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);
  typedef enum logic [1:0] {
    STATE_A,
    STATE_B
  } state_t;
  
  reg state_reg;
  reg [1:0] counter_reg;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state_reg <= STATE_A;
      counter_reg <= 2'b00;
      z <= 0;
    end else begin
      case (state_reg)
        STATE_A: begin
          if (s) begin
            state_reg <= STATE_B;
          end
        end
        STATE_B: begin
          if (w) begin
            counter_reg <= counter_reg + 1;
          end
          if (w && (counter_reg == 2'b01)) begin
            z <= 1;
          end else begin
            z <= 0;
          end
          if (!w) begin
            counter_reg <= 2'b00;
          end
          state_reg <= STATE_A;
        end
      endcase
    end
  end
endmodule