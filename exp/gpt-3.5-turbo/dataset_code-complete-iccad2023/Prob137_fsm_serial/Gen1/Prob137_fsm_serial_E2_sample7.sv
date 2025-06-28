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
reg [7:0] data;
reg [1:0] state, next_state;
reg start_detected;

// FSM
always_ff @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
    count <= 0;
    data <= 8'b0;
    start_detected <= 0;
  end
  else begin
    state <= next_state;
    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = START_BIT;
          start_detected <= 1;
          count <= 0;
          data <= 8'b0;
        end
        else begin
          next_state = IDLE;
          start_detected <= 0;
        end
      end
      START_BIT: begin
        if (count < 8) begin
          next_state = DATA_BITS;
          count <= count + 1;
          data <= {data[6:0], in};
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
          data <= {data[6:0], in};
        end
        else begin
          next_state = STOP_BIT;
          count <= 0;
        end
      end
      STOP_BIT: begin
        if (in == 1'b1 && start_detected) begin
          next_state = IDLE;
          done <= 1;
          start_detected <= 0;
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