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
  parameter START_DETECTED = 2'b01;
  parameter SHIFTING = 2'b10;
  parameter WAIT_FOR_ACK = 2'b11;
  
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
          next_state = START_DETECTED;
        end else begin
          next_state = IDLE;
        end
      end

      START_DETECTED: begin
        shift_ena <= 1;
        next_state = SHIFTING;
      end

      SHIFTING: begin
        shift_ena <= 1;
        if (counting == 4) begin
          next_state = WAIT_FOR_ACK;
        end else begin
          next_state = SHIFTING;
        end
      end

      WAIT_FOR_ACK: begin
        shift_ena <= 0;
        counting <= 1;
        if (done_counting) begin
          done <= 1;
          if (ack) begin
            next_state = IDLE;
          end else begin
            next_state = WAIT_FOR_ACK;
          end
        end else begin
          next_state = WAIT_FOR_ACK;
        end
      end
    endcase
  end

endmodule