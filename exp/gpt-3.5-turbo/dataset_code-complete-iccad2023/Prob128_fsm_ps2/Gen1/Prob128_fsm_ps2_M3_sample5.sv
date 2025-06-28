module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

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
        next_state = (in[3] == 1) ? DONE : BYTE23;
      end
      BYTE23: begin
        next_state = IDLE;
        if (state == BYTE1 && in[3] == 1)
          done <= 1;
        else
          done <= 0;
      end
      default: next_state = IDLE;
    endcase
  end
end

endmodule