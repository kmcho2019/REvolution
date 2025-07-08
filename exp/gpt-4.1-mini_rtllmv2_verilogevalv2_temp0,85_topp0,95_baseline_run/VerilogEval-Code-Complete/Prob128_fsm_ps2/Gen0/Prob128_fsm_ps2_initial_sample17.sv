module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  // State encoding
  localparam IDLE  = 2'd0;
  localparam BYTE2 = 2'd1;
  localparam BYTE3 = 2'd2;

  reg [1:0] state, next_state;

  // Sequential state register and done signal update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // done is asserted only when transitioning from BYTE3 to IDLE (message completed)
      done <= (state == BYTE3);
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      IDLE: begin
        if (in[3])      // First byte of message detected
          next_state = BYTE2;
        else
          next_state = IDLE;
      end
      BYTE2: begin
        // Accept second byte regardless of bit 3
        next_state = BYTE3;
      end
      BYTE3: begin
        // After third byte, move back to IDLE to look for next message
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule