module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // Define states for the FSM
  typedef enum logic [1:0] {S0, S1, S2} state_t;
  reg state, next_state;

  // Shift register for pattern detection
  reg [3:0] shift_reg;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= S0;
      disc <= 0;
      flag <= 0;
      err <= 0;
      shift_reg <= 4'b0;
    end
    else begin
      state <= next_state;

      case (state)
        S0: begin
          shift_reg <= {shift_reg[2:0], in};
          if (shift_reg == 4'b0111) begin
            // Transition to S1 and reset shift register
            next_state = S1;
            shift_reg <= 4'b0;
          end else if (in) begin
            // Transition to S2 for error case
            next_state = S2;
            shift_reg <= 4'b0;
          end else begin
            next_state = S0;
          end
        end

        S1: begin
          shift_reg <= {shift_reg[2:0], in};
          if (shift_reg == 4'b110) begin
            disc <= 1;
            if (!in) begin
              next_state = S0;
            end
            else begin
              next_state = S1;
            end
          end else begin
            flag <= 0;
            disc <= 0;
            if (in) next_state = S1;
            else next_state = S0;
          end
        end

        S2: begin
          if (in) begin
            err <= 1;
            next_state = S0;
          end else begin
            err <= 0;
            next_state = S0;
          end
        end
      endcase
    end
  end
endmodule