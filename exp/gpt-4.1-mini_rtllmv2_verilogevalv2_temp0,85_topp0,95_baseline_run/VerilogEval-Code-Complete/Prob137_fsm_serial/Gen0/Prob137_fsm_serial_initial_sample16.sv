module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  typedef enum reg [2:0] {
    IDLE = 3'd0,
    START = 3'd1,
    DATA = 3'd2,
    STOP = 3'd3,
    WAIT_STOP = 3'd4
  } state_t;

  reg [2:0] state, next_state;
  reg [2:0] bit_count;     // 0 to 7 for data bits count
  reg [7:0] data_shift;    // received data byte (not output here)
  
  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      data_shift <= 8'b0;
      done <= 0;
    end else begin
      state <= next_state;
      done <= 0; // default no done unless set below
      
      case(state)
        IDLE: begin
          if (in == 1'b0) // start bit detected
            bit_count <= 0;
        end
        START: begin
          // no data shifted here, just confirm start bit still 0
        end
        DATA: begin
          // shift in LSB first
          data_shift <= {in, data_shift[7:1]};
          bit_count <= bit_count + 1;
        end
        STOP: begin
          if (in == 1'b1) begin
            done <= 1'b1; // one cycle pulse
          end
        end
        WAIT_STOP: begin
          // no data update here
        end
      endcase
    end
  end
  
  // Next state combinational logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in == 1'b0)
          next_state = START;
      end
      START: begin
        // Confirm start bit still 0
        if (in == 1'b0)
          next_state = DATA;
        else
          next_state = IDLE; // false start, back to idle
      end
      DATA: begin
        if (bit_count == 3'd7)
          next_state = STOP;
        else
          next_state = DATA;
      end
      STOP: begin
        if (in == 1'b1)
          next_state = IDLE;  // byte received ok
        else
          next_state = WAIT_STOP; // bad stop bit, wait for next stop bit
      end
      WAIT_STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule