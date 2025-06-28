module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // Enumerated states for FSM
  typedef enum logic [1:0] {S0, S1, S2} state_t;
  reg state, next_state;
  
  // 5-bit shift register for disc pattern
  reg [4:0] shift_reg;

  // Initialize FSM and outputs
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= S0;
      disc <= 0;
      flag <= 0;
      err <= 0;
      shift_reg <= 0;
    end
    else begin
      state <= next_state;
      case (state)
        S0: begin // Looking for start flag
          shift_reg <= {shift_reg[3:0], in};
          if (shift_reg == 5'b0111110) begin
            disc <= 1;
            shift_reg <= 0; // Reset shift register
            next_state = S1;
          end
          else if (in) begin
            next_state = S0;
          end
          else begin
            next_state = S2;
          end
        end
        S1: begin // Looking for end of the flag
          shift_reg <= {shift_reg[3:0], in};
          if (shift_reg == 5'b01111110) begin
            flag <= 1;
            shift_reg <= 0;
            next_state = S0;
          end
          else if (in) begin
            next_state = S1;
          end
          else begin
            next_state = S2;
          end
        end
        S2: begin // Error state
          if (in) begin
            err <= 1;
            next_state = S2;
          end
          else begin
            err <= 0;
            next_state = S0;
          end
        end
      endcase
    end
  end

endmodule