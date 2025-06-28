module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Enum for states
typedef enum logic [1:0] {
  IDLE,
  RECEIVE,
  STOP
} state_t;

// Registers
reg [2:0] count;
reg [1:0] state, next_state;
reg expected_stop_bit;

// FSM
always_ff @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
    count <= 0;
    expected_stop_bit <= 1;
  end
  else begin
    state <= next_state;
    case (state)
      IDLE: begin
        next_state = (in == 0) ? RECEIVE : IDLE;
        count <= 0;
      end
      RECEIVE: begin
        if (count < 7) begin
          next_state = RECEIVE;
          count <= count + 1;
        end
        else begin
          next_state = STOP;
        end
      end
      STOP: begin
        if (in == expected_stop_bit) begin
          next_state = IDLE;
          done <= 1;
        end
        else begin
          next_state = STOP;
        end
      end
      default: next_state = IDLE;
    endcase
  end
end

endmodule