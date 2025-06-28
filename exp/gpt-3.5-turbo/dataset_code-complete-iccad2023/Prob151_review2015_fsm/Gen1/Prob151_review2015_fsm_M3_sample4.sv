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

  // Define states
  parameter IDLE = 2'b00;
  parameter DETECTED = 2'b01;
  parameter WAIT_FOR_COUNTERS = 2'b10;
  parameter WAIT_FOR_ACK = 2'b11;
  
  // State register and next state
  reg [1:0] state, next_state;

  // State machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // State transitions
  always @* begin
    shift_ena = 0;
    counting = 0;
    done = 0;

    case (state)
      IDLE: begin
        if (data == 4'b1101) begin
          next_state = DETECTED;
        end else begin
          next_state = IDLE;
        end
      end

      DETECTED: begin
        shift_ena = 1;
        if (counting == 4) begin
          next_state = WAIT_FOR_COUNTERS;
        end else begin
          next_state = DETECTED;
        end
      end

      WAIT_FOR_COUNTERS: begin
        if (done_counting) begin
          done = 1;
          next_state = WAIT_FOR_ACK;
        end else begin
          next_state = WAIT_FOR_COUNTERS;
        end
      end

      WAIT_FOR_ACK: begin
        if (ack) begin
          next_state = IDLE;
        end else begin
          next_state = WAIT_FOR_ACK;
        end
      end
    endcase
  end

endmodule