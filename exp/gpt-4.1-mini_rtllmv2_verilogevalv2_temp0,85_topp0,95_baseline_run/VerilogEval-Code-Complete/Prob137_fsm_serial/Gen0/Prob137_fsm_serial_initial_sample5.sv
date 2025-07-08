module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // States encoding
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    RECEIVE = 2'b01,
    STOP = 2'b10,
    WAIT_STOP = 2'b11
  } state_t;

  state_t state, next_state;
  reg [2:0] bit_count; // counts 0 to 7 for 8 data bits

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      // done pulse generation, only for STOP state success
      if (state == STOP && in == 1'b1)
        done <= 1'b1;
      else
        done <= 1'b0;

      // bit_count update only in RECEIVE state
      if (state == RECEIVE)
        bit_count <= bit_count + 3'd1;
      else
        bit_count <= 3'd0;
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      IDLE: begin
        if (in == 1'b0) // start bit detected
          next_state = RECEIVE;
        else
          next_state = IDLE;
      end
      RECEIVE: begin
        if (bit_count == 3'd7) // last data bit received
          next_state = STOP;
        else
          next_state = RECEIVE;
      end
      STOP: begin
        if (in == 1'b1) // correct stop bit
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end
      WAIT_STOP: begin
        if (in == 1'b1) // found stop bit
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule