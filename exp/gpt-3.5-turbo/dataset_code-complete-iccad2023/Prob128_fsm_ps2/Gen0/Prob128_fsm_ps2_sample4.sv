module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Enum for FSM states
typedef enum logic [1:0] {
  IDLE,
  BYTE1,
  BYTE2,
  BYTE3
} state_t;

// Declare state register
reg [1:0] state, next_state;

// Define FSM
always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
  end
  else begin
    state <= next_state;
  end
end

always @* begin
  next_state = state;
  
  case(state)
    IDLE:
      if (in[3] == 1) begin
        next_state = BYTE1;
      end
    BYTE1:
      if (in[3] == 0) begin
        next_state = IDLE;
      end
      else begin
        next_state = BYTE2;
      end
    BYTE2:
      if (in[3] == 0) begin
        next_state = IDLE;
      end
      else begin
        next_state = BYTE3;
      end
    BYTE3:
      next_state = IDLE;
      done <= 1;
  endcase
end

endmodule