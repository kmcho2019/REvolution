module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  reg [1:0] state;
  reg [4:0] shift_reg;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 0;
      shift_reg <= 5'b0;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end
    else begin
      case (state)
        0: begin // Looking for start of flag sequence
          if ((shift_reg == 5'b0111110) && in) begin
            disc <= 1;
          end
          shift_reg <= {shift_reg[3:0], in};
          if (in & (shift_reg == 5'b011111)) begin
            state <= 1;
          end
        end
        1: begin // Looking for end of flag sequence
          if (in & (shift_reg == 5'b0111111)) begin
            flag <= 1;
            state <= 0;
          end
          else if (in) begin // Stay in state 1 if more 1s are received
            state <= 1;
          end
          else begin // Transition back to state 0
            state <= 0;
            disc <= 0; // Reset disc signal
          end
        end
        2: begin // Error state
          if (in) begin
            err <= 1;
          end
          else begin
            state <= 0;
            err <= 0;
          end
        end
      endcase
    end
  end

endmodule