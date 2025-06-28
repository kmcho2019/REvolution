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
  parameter TIMED_OUT = 2'b11;
  
  // Define state register
  reg [1:0] state, next_state;

  // State register always block
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Combinational logic to determine next state
  always @* begin
    case (state)
      IDLE: begin
        shift_ena <= 0;
        counting <= 0;
        if (data == 4'b1101) begin
          next_state = DETECTED;
        end else begin
          next_state = IDLE;
        end
      end

      DETECTED: begin
        shift_ena <= 1;
        if (count == 4) begin
          next_state = WAIT_FOR_COUNTERS;
        end else begin
          next_state = DETECTED;
        end
      end

      WAIT_FOR_COUNTERS: begin
        shift_ena <= 0;
        counting <= 1;
        if (done_counting) begin
          next_state = TIMED_OUT;
        end else begin
          next_state = WAIT_FOR_COUNTERS;
        end
      end

      TIMED_OUT: begin
        done <= 1;
        if (ack) begin
          next_state = IDLE;
        end else begin
          next_state = TIMED_OUT;
        end
      end
    endcase
  end

endmodule