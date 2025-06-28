module TimerControl (
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
    DETECT_START,
    SHIFT,
    WAIT_ACK
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
    shift_ena = 0;
   
    case (state)
      IDLE: begin
        if (data == 4'b1101) begin
          next_state = DETECT_START;
        end else begin
          next_state = IDLE;
        end
      end

      DETECT_START: begin
        shift_ena = 1;
        next_state = SHIFT;
      end

      SHIFT: begin
        if (done_counting) begin
          counting = 0;
          done = 1;
          next_state = WAIT_ACK;
        end else begin
          counting = 1;
          next_state = SHIFT;
        end
      end

      WAIT_ACK: begin
        if (ack) begin
          next_state = IDLE;
          done = 0;
        end else begin
          next_state = WAIT_ACK;
        end
      end

      default: begin
        next_state = IDLE;
      end
    endcase
  end

endmodule