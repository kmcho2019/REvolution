module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Enum for states
typedef enum logic [2:0] {
  IDLE,
  START_BIT,
  DATA_BIT_0,
  DATA_BITS_1_6,
  DATA_BIT_7,
  STOP_BIT
} state_t;

// Registers
reg [2:0] count;
reg [9:0] data; // 10 bits to store start bit, data bits, and stop bit
reg [2:0] state, next_state;

// FSM
always_ff @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
    count <= 0;
    data <= 10'b0;
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
        next_state = DATA_BIT_0;
        data <= {data[8:0], in};
      end
      DATA_BIT_0: begin
        next_state = DATA_BITS_1_6;
        count <= count + 1;
        data <= {data[8:0], in};
      end
      DATA_BITS_1_6: begin
        if (count < 6) begin
          next_state = DATA_BITS_1_6;
          count <= count + 1;
          data <= {data[8:0], in};
        end
        else begin
          next_state = DATA_BIT_7;
          count <= count + 1;
          data <= {data[8:0], in};
        end
      end
      DATA_BIT_7: begin
        next_state = STOP_BIT;
        count <= count + 1;
        data <= {data[8:0], in};
      end
      STOP_BIT: begin
        if (in == 1'b1) begin
          next_state = IDLE;
          done <= 1;
        end
        else begin
          next_state = STOP_BIT;
        end
      end
      default: next_state = IDLE;
    endcase
  end
end

endmodule