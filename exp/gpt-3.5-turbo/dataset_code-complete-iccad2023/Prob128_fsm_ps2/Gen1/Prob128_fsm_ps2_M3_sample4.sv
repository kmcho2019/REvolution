module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
typedef enum logic [1:0] {
  IDLE,
  FIRST_BYTE,
  SECOND_BYTE,
  THIRD_BYTE
} state_t;

// Define signals
reg [1:0] state, next_state;

// State transition and logic
always_ff @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
  end
  else begin
    state <= next_state;
    case(state)
      IDLE:
        if (in[3] == 1) begin
          next_state = FIRST_BYTE;
        end
        else begin
          next_state = IDLE;
        end
      FIRST_BYTE:
        next_state = SECOND_BYTE;
        if (in[3] == 1) begin
          next_state = THIRD_BYTE;
        end
      SECOND_BYTE: 
        next_state = THIRD_BYTE;
        if (in[3] == 1) begin
          next_state = THIRD_BYTE;
        end
      THIRD_BYTE:
        next_state = IDLE;
    endcase
  end
end

endmodule