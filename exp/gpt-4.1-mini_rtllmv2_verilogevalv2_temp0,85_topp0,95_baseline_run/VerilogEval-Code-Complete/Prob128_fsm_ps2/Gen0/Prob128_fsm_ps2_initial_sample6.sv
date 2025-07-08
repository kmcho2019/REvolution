module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  typedef enum logic [1:0] {IDLE=2'd0, BYTE2=2'd1, BYTE3=2'd2} state_t;
  state_t state, next_state;

  // State transition
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic and done signal
  always @(*) begin
    done = 1'b0;
    case (state)
      IDLE: begin
        if (in[3]) 
          next_state = BYTE2;
        else
          next_state = IDLE;
      end
      BYTE2: begin
        next_state = BYTE3;
      end
      BYTE3: begin
        done = 1'b1; // signal done on cycle after receiving 3rd byte
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule