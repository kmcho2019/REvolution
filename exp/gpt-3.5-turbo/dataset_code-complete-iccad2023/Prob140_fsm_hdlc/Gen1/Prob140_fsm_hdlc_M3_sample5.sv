module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  reg [1:0] state;
  reg disc, flag, err;
  reg [4:0] shift_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00;
      disc <= 0;
      flag <= 0;
      err <= 0;
      shift_reg <= 5'b0;
    end
    else begin
      case (state)
        2'b00: begin // STATE_IDLE
          if (in) begin
            shift_reg <= {shift_reg[3:0], in};
            if (shift_reg == 5'b0111110)
              disc <= 1;
            else if (in)
              state <= 2'b01; // Transition to STATE_FLAG
          end
        end
        2'b01: begin // STATE_FLAG
          if (!in)
            state <= 2'b00; // Transition back to idle
          else if (shift_reg == 5'b01111110)
            flag <= 1;
          else if (in)
            state <= 2'b02; // Transition to STATE_ERR
          disc <= 0; // Reset disc
        end
        2'b02: begin // STATE_ERR
          if (in) begin
            err <= 1;
          end
          else begin
            err <= 0;
            state <= 2'b00; // Transition back to idle
          end
        end
      endcase
    end
  end

endmodule