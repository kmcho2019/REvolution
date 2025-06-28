module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // Registers for state and output signals
  reg [2:0] state;
  reg disc, flag, err;

  // 5-bit shift register for disc pattern
  reg [4:0] shift_reg;

  // Assign initial states
  initial begin
    state <= 3'b000; // Initial state when previous input is 0
    disc <= 0;
    flag <= 0;
    err <= 0;
  end

  always @(posedge clk) begin
    if (reset) begin
      state <= 3'b000;
      shift_reg <= 5'b0;
      disc <= 0;
    end
    else begin
      case (state)
        3'b000: begin // State 0 - Looking for the start of a flag sequence
          shift_reg <= {shift_reg[3:0], in};
          if (shift_reg == 5'b0111110) begin
            disc <= 1;
            shift_reg <= 5'b0;
          end
          if (in) begin
            state <= 3'b001;
          end
        end
        3'b001: begin // State 1 - Looking for the end of a flag sequence
          if (in) begin
            state <= 3'b010;
            flag <= 1;
          end
          else begin
            state <= 3'b000;
            disc <= 0;
          end
        end
        3'b010: begin // State 2 - End of flag sequence detected
          if (!in) begin
            state <= 3'b000;
            flag <= 0;
          end
        end
        3'b011: begin // State 3 - Error state
          if (in) begin
            err <= 1;
          end
          else begin
            state <= 3'b000;
            err <= 0;
          end
        end
        default: begin
          state <= 3'b000;
          disc <= 0;
          flag <= 0;
          err <= 0; // Reset to default state if unknown state is reached
        end
      endcase
    end
  end

endmodule