module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);
  
  // Registers for state and shift register
  reg [1:0] state;
  reg [5:0] shift_reg;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 0;
      shift_reg <= 6'b0;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end
    else begin
      case (state)
        0: begin // Looking for start of flag pattern
          if (in) begin
            shift_reg <= {shift_reg[4:0], in};
            if (shift_reg == 6'b0111110) begin
              disc <= 1;
              shift_reg <= 6'b0;
            end
            else if (in) begin
              state <= 1;
            end
          end
        end
        1: begin // Looking for end of flag pattern
          if (in) begin
            shift_reg <= {shift_reg[4:0], in};
            if (shift_reg == 6'b01111110) begin
              flag <= 1;
              shift_reg <= 6'b0;
              state <= 0;
            end
          end
          else begin
            shift_reg <= 6'b0;
            state <= 0;
          end
        end
        2: begin // Error state
          if (in) begin
            err <= 1;
          end
          else begin
            err <= 0;
            state <= 0;
          end
        end
      endcase
    end
  end

endmodule