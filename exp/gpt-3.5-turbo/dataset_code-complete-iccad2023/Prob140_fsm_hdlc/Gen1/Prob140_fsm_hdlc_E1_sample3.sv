module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

reg [6:0] shift_reg;
reg [1:0] state;

always @(posedge clk or posedge reset)
begin
  if (reset) begin
    shift_reg <= 7'b0;
    state <= 2'b00;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  else begin
    shift_reg <= {shift_reg[5:0], in};
    case (state)
      2'b00: begin // State 0: Looking for the start of a flag sequence
        if (shift_reg == 7'b0111110) begin
          disc <= 1;
          state <= 2'b01;
        end
        else if (in)
          state <= 2'b01;
      end
      2'b01: begin // State 1: Detected 5 consecutive 1s
        if (in)
          state <= 2'b10;
        else
          state <= 2'b00;
      end
      2'b10: begin // State 2: Detected 6 consecutive 1s
        flag <= 1;
        state <= 2'b00;
      end
      2'b11: begin // State 3: Detected 7 or more consecutive 1s
        err <= 1;
        state <= 2'b00;
      end
      default: state <= 2'b00;
    endcase
  end
end

endmodule