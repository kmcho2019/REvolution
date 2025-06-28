module TopModule (
  input clk,
  input in,
  input reset,
  output [7:0] out_byte,
  output done
);

reg [8:0] byte_shift_reg; // 8-bit shift register to capture the entire byte
reg [2:0] state, next_state; // 3-bit state variable

parameter IDLE = 3'b000, START_BIT_FOUND = 3'b001, BYTE_RECEIVED = 3'b010, STOP_BIT_FOUND = 3'b011;

always @ (posedge clk or posedge reset)
begin
  if (reset)
  begin
    byte_shift_reg <= 9'b0;
    state <= IDLE;
    done <= 0;
  end
  else
  begin
    byte_shift_reg <= {byte_shift_reg[7:0], in};
    case (state)
      IDLE:
        if (in == 0)
          next_state = START_BIT_FOUND;
        else
          next_state = IDLE;
      START_BIT_FOUND:
        next_state = BYTE_RECEIVED;
      BYTE_RECEIVED:
        if (byte_shift_reg[8] == 1)
          next_state = STOP_BIT_FOUND;
        else
          next_state = BYTE_RECEIVED;
      STOP_BIT_FOUND:
        if (in == 1)
        begin
          out_byte <= byte_shift_reg[7:0];
          done <= 1;
          next_state = IDLE;
        end
        else
          next_state = STOP_BIT_FOUND;
      default:
        next_state = IDLE;
    endcase
  end
  state <= next_state;
end

endmodule