module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // Registers for state, shift register, and previous inputs
  reg [1:0] state;
  reg [3:0] shift_reg;
  reg prev_in;

  // Assign initial states
  initial begin
    state <= 0;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end

  always @(posedge clk) begin
    if (reset) begin
      state <= 0;
      prev_in <= 0;
      shift_reg <= 4'b0;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end
    else begin
      prev_in <= in;
      case (state)
        0: begin // Looking for 0111 pattern
          shift_reg <= {shift_reg[2:0], in};
          if (shift_reg == 4'b0111) begin
            state <= 1;
          end
        end
        1: begin // Check for disc, flag, or err conditions
          if (shift_reg == 4'b0111) begin
            disc <= 1;
          end
          else if (shift_reg == 4'b0111110) begin
            flag <= 1;
          end
          else if (shift_reg == 4'b0111111) begin
            err <= 1;
          end
          else if (in) begin
            state <= 2;
          end
        end
        2: begin // Error state, transition back to state 0
          state <= 0;
          disc <= 0;
          flag <= 0;
          err <= 0;
        end
      endcase
    end
  end

endmodule