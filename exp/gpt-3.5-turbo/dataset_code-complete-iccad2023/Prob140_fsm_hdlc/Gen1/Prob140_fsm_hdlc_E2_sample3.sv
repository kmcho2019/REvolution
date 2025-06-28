module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // Registers for state, previous input, and count for consecutive ones
  reg [1:0] state;
  reg prev_in;
  reg [2:0] count_ones;

  // 5-bit shift register for disc pattern
  reg [4:0] shift_reg;

  // Assign initial states
  always @*
    if (reset) begin
      state <= 0;
      prev_in <= 0;
      shift_reg <= 5'b0;
      disc <= 0;
      flag <= 0;
      err <= 0;
      count_ones <= 0;
    end
    else begin
      prev_in <= in;
      case (state)
        0: begin // Looking for start of flag sequence
          shift_reg <= {shift_reg[3:0], in};
          if (shift_reg == 5'b0111110) begin
            disc <= 1;
            shift_reg <= 5'b0;
          end
          if (in) begin
            state <= 1;
          end
        end
        1: begin // Looking for end of flag sequence
          if (prev_in == 1 && in == 0) begin
            state <= 0;
            disc <= 0;
            flag <= 1;
          end
        end
        2: begin // Error state
          if (in) begin
            count_ones <= count_ones + 1;
            if (count_ones >= 6) begin
              err <= 1;
            end
          end
          else begin
            count_ones <= 0;
            state <= 0;
            err <= 0;
          end
        end
      endcase
    end

endmodule