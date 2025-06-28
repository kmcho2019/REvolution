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
    STATE_B,
    STATE_C
  } state_t;

  // Declare state and next state registers
  reg state_reg, next_state_reg;

  // Declare counter register
  reg [1:0] w_counter;
  
  // State and output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state_reg <= STATE_A;
      w_counter <= 2'b00;
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
            w_counter <= w_counter + 1;
          end
          next_state_reg = STATE_C;
        end
        STATE_C: begin
          next_state_reg = STATE_A;
        end
      endcase
    end
  end

  // Output z logic
  always @(posedge clk) begin
    case (state_reg)
      STATE_C: begin
        if (w_counter == 2'b10) begin
          z <= 1;
        end else begin
          z <= 0;
        end
      end
      default: begin
        z <= 0;
      end
    endcase
  end

endmodule