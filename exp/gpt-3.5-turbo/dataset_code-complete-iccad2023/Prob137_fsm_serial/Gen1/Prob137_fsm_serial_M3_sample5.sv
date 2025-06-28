module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Enum for states
typedef enum logic [1:0] {
  IDLE,
  START_BIT,
  DATA_BITS,
  STOP_BIT
} state_t;

// Registers
reg [2:0] count;
reg [6:0] data;
reg [1:0] state, next_state;

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
        if (in == 1'b0)
          next_state = START_BIT;
        else
          next_state = IDLE;
      end
      START_BIT: begin
        if (count < 8) begin
          next_state = DATA_BITS;
          count <= count + 1;
          data <= {data[5:0], in};
        end
        else begin
          next_state = STOP_BIT;
          count <= 0;
        end
      end
      DATA_BITS: begin
        if (count < 8) begin
          next_state = DATA_BITS;
          count <= count + 1;
          data <= {data[6:1], in};
        end
        else begin
          next_state = STOP_BIT;
          count <= 0;
        end
      end
      STOP_BIT: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = STOP_BIT;
        done <= (in == 1'b1);
      end
      default: next_state = IDLE;
    endcase
  end
end

endmodule