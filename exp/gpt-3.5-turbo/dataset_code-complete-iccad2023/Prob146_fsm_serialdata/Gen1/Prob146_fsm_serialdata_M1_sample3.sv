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
  DATA_BITS,
  STOP_BIT
} state_t;

reg [3:0] state, next_state;
reg [7:0] byte_buffer;
reg [2:0] data_counter;
reg done;

always_ff @(posedge clk or posedge reset)
begin
  if (reset)
  begin
    state <= IDLE;
    done <= 0;
    byte_buffer <= 8'b0;
    data_counter <= 3'b0;
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
      begin
        next_state = DATA_BITS;
        data_counter <= 3'b0;
      end
    DATA_BITS:
      begin
        byte_buffer[data_counter] <= in;
        data_counter <= data_counter + 1;
        next_state = (data_counter == 3'b111) ? STOP_BIT : DATA_BITS;
      end
    STOP_BIT:
      begin
        next_state = (in) ? IDLE : START_BIT;
        if (!in)
        begin
          out_byte <= byte_buffer;
          done <= 1;
        end
      end
    default:
      next_state = IDLE;
  endcase
end

endmodule