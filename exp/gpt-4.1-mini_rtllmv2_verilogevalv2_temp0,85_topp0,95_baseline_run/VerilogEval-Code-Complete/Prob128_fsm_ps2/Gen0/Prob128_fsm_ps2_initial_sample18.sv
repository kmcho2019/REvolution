module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  typedef enum logic [1:0] {
    WAIT_START = 2'd0,
    BYTE_2     = 2'd1,
    BYTE_3     = 2'd2
  } state_t;

  state_t state, next_state;

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset) begin
      state <= WAIT_START;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // done is asserted only for one cycle after third byte
      done <= (state == BYTE_3);
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      WAIT_START: begin
        if (in[3]) begin
          next_state = BYTE_2;
        end else begin
          next_state = WAIT_START;
        end
      end
      BYTE_2: begin
        next_state = BYTE_3;
      end
      BYTE_3: begin
        // After third byte, go back to waiting for start byte (in[3]=1)
        if (in[3]) begin
          next_state = BYTE_2;
        end else begin
          next_state = WAIT_START;
        end
      end
      default: next_state = WAIT_START;
    endcase
  end

endmodule