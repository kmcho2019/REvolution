module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // FSM states
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    DATA = 2'b01,
    STOP = 2'b10,
    WAIT_STOP = 2'b11
  } state_t;

  state_t state, next_state;

  reg [2:0] bit_count;   // counts 0 to 7 data bits
  reg [7:0] data_reg;    // stores the data bits shifted in

  // State register update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      data_reg <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low, set high only when stop bit accepted

      case(state)
        IDLE: begin
          // waiting for start bit (0)
          if (in == 1'b0) begin
            bit_count <= 3'd0;
            data_reg <= 8'd0;
          end
        end

        DATA: begin
          // shift in current bit, LSB first
          data_reg <= {in, data_reg[7:1]};
          bit_count <= bit_count + 1'b1;
        end

        STOP: begin
          // nothing to do here except later in next_state logic
        end

        WAIT_STOP: begin
          // waiting for stop bit (1)
          // no data collection here
        end
      endcase
    end
  end

  // Next state logic and output logic
  always @(*) begin
    next_state = state; // default to no state change

    case(state)
      IDLE: begin
        if (reset) begin
          next_state = IDLE;
        end else if (in == 1'b0) begin
          // start bit detected, move to DATA
          next_state = DATA;
        end
      end

      DATA: begin
        if (bit_count == 3'd7) begin
          // after capturing 8 bits, go to STOP to check stop bit next cycle
          next_state = STOP;
        end else begin
          next_state = DATA;
        end
      end

      STOP: begin
        if (in == 1'b1) begin
          // stop bit correct: output data, signal done, go IDLE
          next_state = IDLE;
        end else begin
          // stop bit incorrect: go wait for stop bit
          next_state = WAIT_STOP;
        end
      end

      WAIT_STOP: begin
        if (in == 1'b1) begin
          // stop bit found, go IDLE
          next_state = IDLE;
        end else begin
          next_state = WAIT_STOP;
        end
      end
    endcase
  end

  // Output and done signal generation in clocked always block
  // We need to set done and out_byte at correct timing:
  // done is asserted for one clk cycle when stop bit is correct at STOP state
  always @(posedge clk) begin
    if (reset) begin
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      if (state == STOP && in == 1'b1) begin
        // correct stop bit received, latch output and assert done
        out_byte <= data_reg;
        done <= 1'b1;
      end else begin
        done <= 1'b0;
      end
    end
  end

endmodule