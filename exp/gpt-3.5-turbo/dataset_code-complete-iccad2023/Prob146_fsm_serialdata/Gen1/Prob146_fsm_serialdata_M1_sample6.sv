module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

typedef enum logic [3:0] {
  IDLE,
  START_BIT,
  READ_DATA_0,
  READ_DATA_1,
  READ_DATA_2,
  READ_DATA_3,
  READ_DATA_4,
  READ_DATA_5,
  READ_DATA_6,
  READ_DATA_7,
  STOP_BIT
} state_t;

reg [3:0] state, next_state;
reg [7:0] data_buffer;

always_ff @(posedge clk or posedge reset)
begin
  if (reset)
  begin
    state <= IDLE;
    done <= 0;
    data_buffer <= 8'b0;
    out_byte <= 8'b0;
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
      next_state = READ_DATA_0;
    READ_DATA_0: 
      begin
        data_buffer <= {data_buffer[6:0], in};
        next_state = READ_DATA_1;
      end
    // Repeat for READ_DATA_1 to READ_DATA_6
    READ_DATA_6: 
      begin
        data_buffer <= {data_buffer[6:0], in};
        next_state = READ_DATA_7;
      end
    READ_DATA_7: 
      begin
        data_buffer <= {data_buffer[6:0], in};
        next_state = STOP_BIT;
      end
    STOP_BIT:
      begin
        if (in) // Check for correct stop bit
        begin
          out_byte <= data_buffer;
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