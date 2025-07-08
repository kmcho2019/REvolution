module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  typedef enum logic [1:0] {
    IDLE  = 2'b00,
    BYTE2 = 2'b01,
    BYTE3 = 2'b10
  } state_t;

  state_t state, next_state;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // done is asserted only one cycle immediately after third byte received
      done <= (state == BYTE3);
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      IDLE: begin
        if (in[3])       // start of message detected
          next_state = BYTE2;
        else
          next_state = IDLE;
      end

      BYTE2: begin
        next_state = BYTE3;
      end

      BYTE3: begin
        if (in[3])      // new message starts immediately after previous
          next_state = BYTE2;
        else
          next_state = IDLE;
      end

      default: next_state = IDLE;
    endcase
  end

endmodule