module TopModule (
  input clk,
  input in,
  input reset,
  output [7:0] out_byte,
  output done
);

typedef enum logic [3:0] {
  IDLE,
  START_BIT,
  DATA_BITS_0,
  DATA_BITS_1,
  DATA_BITS_2,
  DATA_BITS_3,
  DATA_BITS_4,
  DATA_BITS_5,
  DATA_BITS_6,
  DATA_BITS_7,
  STOP_BIT
} state_t;

reg [3:0] state, next_state;
reg [7:0] byte_buffer;
reg done;

always_ff @(posedge clk or posedge reset)
begin
  if (reset)
  begin
    state <= IDLE;
    done <= 0;
    byte_buffer <= 8'b0;
  end
  else
    state <= next_state;
end

always_comb
begin
  case(state)
    IDLE:
      next_state = (in) ? START_BIT : IDLE;
    START_BIT:
      next_state = DATA_BITS_0;
    DATA_BITS_0: // etc. for DATA_BITS_1 to DATA_BITS_7
      next_state = (state == DATA_BITS_7) ? STOP_BIT : state + 1;
    STOP_BIT:
      begin
        if (!in)
        begin
          out_byte <= byte_buffer;
          done <= 1;
          next_state = IDLE;
        end
        else
          next_state = STOP_BIT;
      end
    default:
      next_state = IDLE;
  endcase
end

endmodule