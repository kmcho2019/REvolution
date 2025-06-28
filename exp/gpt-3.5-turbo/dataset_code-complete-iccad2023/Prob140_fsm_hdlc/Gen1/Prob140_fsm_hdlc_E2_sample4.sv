module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // Registers for state, timeout counter, and shift register
  reg [1:0] state;
  reg [2:0] timeout;
  reg [4:0] shift_reg;

  // Initial states
  initial begin
    state <= 0;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end

  // State machine definition
  always @(posedge clk) begin
    if (reset) begin
      state <= 0;
      timeout <= 0;
      disc <= 0;
    end
    else begin
      case (state)
        0: begin  // Looking for start of flag sequence
          if (in == 1 && shift_reg == 5'b011110) begin
            state <= 1;
            timeout <= 3; // Timeout for detecting 01111110
          end
          else begin
            shift_reg <= {shift_reg[3:0], in};
            if (shift_reg == 5'b011110) begin
              disc <= 1;
              shift_reg <= 5'b0;
            end
          end
        end
        1: begin  // Looking for end of flag sequence within timeout
          if (timeout > 0) begin
            if (in == 1 && shift_reg == 5'b0111110) begin
              flag <= 1;
              state <= 0;
              shift_reg <= 5'b0;
              timeout <= 0;
            end
            else if (in == 1 && shift_reg == 5'b0111111) begin
              err <= 1;
              state <= 0;
              shift_reg <= 5'b0;
              timeout <= 0;
            end
            else begin
              shift_reg <= {shift_reg[3:0], in};
              timeout <= timeout - 1;
            end
          end
          else begin
            state <= 0;
            timeout <= 0;
          end
        end
      endcase
    end
  end

endmodule