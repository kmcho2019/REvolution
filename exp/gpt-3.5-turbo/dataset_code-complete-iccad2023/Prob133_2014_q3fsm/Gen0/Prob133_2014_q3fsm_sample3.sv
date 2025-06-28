module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // Define the states
  typedef enum logic [1:0] {
    STATE_A,
    STATE_B
  } state_t;
  
  // Declare state register
  reg state_reg, next_state_reg;
  
  // Declare counter register
  reg [1:0] counter_reg;

  // State and output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state_reg <= STATE_A;
      counter_reg <= 2'b00;
      z <= 0;
    end else begin
      state_reg <= next_state_reg;
      // State machine transitions
      case (state_reg)
        STATE_A: begin
          if (s) begin
            next_state_reg = STATE_B;
          end else begin
            next_state_reg = STATE_A;
          end
        end
        STATE_B: begin
          if (w) begin
            counter_reg <= counter_reg + 1;
          end
          next_state_reg = STATE_A;
        end
      endcase
    end
  end
  
  // Output z logic
  always @(posedge clk) begin
    if (state_reg == STATE_B && counter_reg == 2'b10) begin
      z <= 1;
    end else begin
      z <= 0;
    end
  end

endmodule