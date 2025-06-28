module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // Registers for state and previous input
  reg [1:0] state;
  reg prev_in;

  // 5-bit shift register for the disc pattern
  reg [4:0] shift_reg;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 0;
      prev_in <= 0;
      shift_reg <= 5'b0;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end
    else begin
      prev_in <= in;
      case (state)
        0: begin // Start of flag sequence
          if (prev_in & !in) begin
            shift_reg <= {shift_reg[3:0], in};
            if (shift_reg == 5'b0111110) begin
              disc <= 1;
              shift_reg <= 5'b0;
            end
            else if (in)
              state <= 1;
          end
        end
        1: begin // End of flag sequence
          if (prev_in & !in) begin
            if (in) begin // Flag detected
              state <= 2;
              flag <= 1;
            end
            else begin // Back to start state
              state <= 0;
              disc <= 0;
            end
          end
        end
        2: begin // Error state
          if (prev_in & in) begin
            err <= 1; // 7 or more 1s detected
          end
          else begin
            err <= 0;
            state <= 0; // Reset to start state
          end
        end
      endcase
    end
  end

endmodule