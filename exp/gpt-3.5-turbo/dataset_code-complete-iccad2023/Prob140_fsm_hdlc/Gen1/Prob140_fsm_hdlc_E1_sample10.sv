module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

reg [3:0] state, next_state;
reg [4:0] shift_reg;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 4'b0000;
    shift_reg <= 5'b00000;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  else begin
    state <= next_state;
    case (state)
      4'b0000: begin // State S0: Looking for start of 0111110 pattern
        shift_reg <= {shift_reg[3:0], in};
        next_state = (shift_reg == 5'b0111110) ? 4'b0001 : 4'b0000;
      end
      4'b0001: begin // State S1: Looking for end of 0111110 pattern
        shift_reg <= {shift_reg[3:0], in};
        disc <= 1;
        next_state = (shift_reg == 5'b0111110) ? 4'b0001 :
                     (in == 1) ? 4'b0010 : 4'b0000;
      end
      4'b0010: begin // State S2: Error state - 7 or more 1s
        err <= 1;
        next_state = (in == 0) ? 4'b0000 : 4'b0010;
      end
      4'b0011: begin // State S3: Flag for frame boundary
        flag <= 1;
        next_state = (in == 0) ? 4'b0000 : 4'b0011;
      end
    endcase
  end
end

endmodule