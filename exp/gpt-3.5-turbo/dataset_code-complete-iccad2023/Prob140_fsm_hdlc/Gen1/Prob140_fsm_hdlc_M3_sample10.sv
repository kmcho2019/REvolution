module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // Registers for state, prev_in, and count of consecutive ones
  reg [2:0] state;
  reg prev_in;
  reg [2:0] count_ones;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 3'b000;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end
    else begin
      prev_in <= in;
      case (state)
        3'b000: begin // State 0: Look for start of flag/discard sequence (0111110)
          if ({count_ones, in} == 7'b0111110) begin
            state <= 3'b001;
            disc <= 1;
            count_ones <= 0;
          end
          else begin
            count_ones <= (in) ? count_ones + 1 : 0;
          end
        end
        3'b001: begin // State 1: Look for end of flag sequence (01111110) or 7 or more 1s
          if ({count_ones, in} == 8'b01111110) begin
            state <= 3'b000;
            flag <= 1;
            count_ones <= 0;
          end
          else if (count_ones == 6) begin
            state <= 3'b000;
            disc <= 1;
            count_ones <= 0;
          end
          else if (count_ones >= 7) begin
            state <= 3'b000;
            err <= 1;
            count_ones <= 0;
          end
          else begin
            count_ones <= (in) ? count_ones + 1 : 0;
          end
        end
      endcase
    end
  end

endmodule