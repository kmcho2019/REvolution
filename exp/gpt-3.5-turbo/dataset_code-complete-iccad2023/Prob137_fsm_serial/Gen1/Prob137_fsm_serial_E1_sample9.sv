module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Define the states
typedef enum logic [2:0] {
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
  STOP_BIT,
  VALID_CHECK
} state_t;

// Registers
reg [2:0] data;
reg [3:0] count;
reg [2:0] state, next_state;

// FSM
always_ff @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
    count <= 0;
    data <= 0;
  end
  else begin
    state <= next_state;
    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = START_BIT;
          count <= 0;
          data <= 0;
        end
        else begin
          next_state = IDLE;
        end
      end
      START_BIT: begin
        next_state = DATA_BITS_0;
      end
      DATA_BITS_0 to DATA_BITS_6: begin
        if (count < 7) begin
          next_state = state + 1;
          data <= {data[6:0], in};
          count <= count + 1;
        end
        else begin
          next_state = STOP_BIT;
          data <= {data[6:0], in};
          count <= count + 1;
        end
      end
      DATA_BITS_7: begin
        next_state = VALID_CHECK;
        data <= {data[6:0], in};
        count <= 8;
      end
      STOP_BIT: begin
        if (in == 1'b1) begin
          next_state = IDLE;
          done <= 1;
        end
        else begin
          next_state = IDLE;
        end
      end
      VALID_CHECK: begin
        if (in == 1'b1 && data == 9'b110000001) begin
          next_state = IDLE;
          done <= 1;
        end
        else begin
          next_state = IDLE;
        end
      end
      default: next_state = IDLE;
    endcase
  end
end

endmodule