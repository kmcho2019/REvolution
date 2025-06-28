module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // Registers for state and shift register
  reg [4:0] shift_reg;
  reg [2:0] state;

  // Assign initial states
  initial begin
    shift_reg <= 5'b0;
    state <= 3'b000; // Initial state is as if the previous input were 0
    disc <= 0;
    flag <= 0;
    err <= 0;
  end

  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 5'b0;
      state <= 3'b000;
      disc <= 0;
    end
    else begin
      // Shift the register with the current input
      shift_reg <= {in, shift_reg[4:1]};

      // State machine transitions
      case (state)
        3'b000: begin // Looking for start of flag sequence
          if (shift_reg == 5'b0111110) begin
            disc <= 1;
            state <= 3'b001;
          end
        end
        3'b001: begin // Looking for end of flag sequence
          if (shift_reg == 5'b01111110) begin
            flag <= 1;
            state <= 3'b010;
          end
          else if (shift_reg[4] == 1) begin
            state <= 3'b011;
          end
        end
        3'b010: begin // Error state
          if (shift_reg[4] == 1) begin
            err <= 1;
            state <= 3'b011;
          end
          else begin
            flag <= 0;
            state <= 3'b000;
          end
        end
        3'b011: begin // Continue in error state
          if (shift_reg[4] == 0) begin
            err <= 0;
            state <= 3'b000;
          end
        end
      endcase

    end
  end

endmodule