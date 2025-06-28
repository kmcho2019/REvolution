module TopModule (
  input clk,
  input reset,
  input data,
  output reg shift_ena,
  output reg counting,
  input done_counting,
  output reg done,
  input ack
);

  typedef enum logic [2:0] {
    IDLE,
    DETECT_PATTERN,
    SHIFT_IN_BITS,
    WAITING_FOR_COUNTERS,
    NOTIFY_USER,
    WAIT_FOR_ACK
  } state_type;

  reg [2:0] state, next_state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    next_state = state;
    shift_ena = 0;
    counting = 0;
    done = 0;
  
    case (state)
      IDLE: begin
        if (data == 4'b1101) begin
          next_state = DETECT_PATTERN;
        end
      end
      
      DETECT_PATTERN: begin
        shift_ena = 1;
        next_state = SHIFT_IN_BITS;
      end
      
      SHIFT_IN_BITS: begin
        if (counting == 4) begin
          counting = 0;
          next_state = WAITING_FOR_COUNTERS;
        end else begin
          counting = counting + 1;
          next_state = SHIFT_IN_BITS;
        end
      end
      
      WAITING_FOR_COUNTERS: begin
        if (done_counting) begin
          next_state = NOTIFY_USER;
        end
      end
      
      NOTIFY_USER: begin
        done = 1;
        next_state = WAIT_FOR_ACK;
      end
      
      WAIT_FOR_ACK: begin
        if (ack) begin
          next_state = IDLE;
        end
      end
    endcase
  end

endmodule