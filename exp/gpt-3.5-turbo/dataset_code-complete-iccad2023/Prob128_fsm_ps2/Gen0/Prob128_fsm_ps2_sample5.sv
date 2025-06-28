module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

typedef enum logic [1:0] {
  IDLE,
  BYTE1,
  BYTE23
} state_t;

reg [1:0] state, next_state;

always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
  end
  else begin
    state <= next_state;
    case (state)
      IDLE: begin
        if (in[3] == 1)
          next_state = BYTE1;
        else
          next_state = IDLE;
      end
      BYTE1: begin
        next_state = BYTE23;
      end
      BYTE23: begin
        next_state = IDLE;
        done <= 1;
      end
      default: next_state = IDLE;
    endcase
  end
end

endmodule