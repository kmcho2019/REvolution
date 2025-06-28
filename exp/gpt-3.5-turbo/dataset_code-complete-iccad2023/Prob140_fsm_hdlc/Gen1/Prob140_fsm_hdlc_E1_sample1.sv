module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  reg [2:0] state;
  reg [6:0] shift_reg;
  
  always @ (posedge clk or posedge reset)
  begin
    if (reset) begin
      state <= 3'b000; // Initial state
      shift_reg <= 7'b0; // Clear shift register
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
    end
    else begin
      case (state)
        3'b000: // IDLE state
          begin
            if (in)
              state <= 3'b001; // Move to GOT_1 if input is 1
          end
        3'b001: // GOT_1 state
          begin
            shift_reg <= {shift_reg[5:0], in}; // Shift register for 0111110 pattern
            if (shift_reg == 7'b0111110) begin
              disc <= 1'b1; // Signal a bit needs to be discarded
              shift_reg <= 7'b0; // Reset shift register
              state <= 3'b000; // Back to IDLE state
            end else if (in)
              state <= 3'b010; // Move to GOT_01 if input is 1
            else
              state <= 3'b000; // Back to IDLE state
          end
        3'b010: // GOT_01 state
          begin
            if (in)
              state <= 3'b011; // Move to GOT_011 if input is 1
            else
              state <= 3'b000; // Back to IDLE state
          end
        3'b011: // GOT_011 state
          begin
            if (in) begin
              err <= 1'b1; // Error signal for 7 or more 1s
              state <= 3'b000; // Back to IDLE state
            end else begin
              flag <= 1'b1; // Flag signal for 01111110
              state <= 3'b000; // Back to IDLE state
            end
          end
      endcase
    end
  end

endmodule