module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  localparam IDLE      = 3'd0;
  localparam START     = 3'd1;
  localparam DATA      = 3'd2;
  localparam STOP      = 3'd3;
  localparam WAIT_STOP = 3'd4;

  reg [2:0] state, next_state;
  reg [2:0] bit_count;    // counts 0 to 7 for data bits
  reg [7:0] data_shift;   // stores received data bits

  // State register and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 1'b0;
      bit_count <= 3'd0;
      data_shift <= 8'd0;
    end else begin
      state <= next_state;

      // Default done low, only asserted in STOP state when stop bit correct
      done <= 1'b0;

      case(state)
        IDLE: begin
          bit_count <= 3'd0;
          data_shift <= 8'd0;
        end
        START: begin
          bit_count <= 3'd0;
          data_shift <= 8'd0;
        end
        DATA: begin
          data_shift <= {in, data_shift[7:1]}; // LSB first shift: new bit goes to MSB position, shift right
          bit_count <= bit_count + 1'b1;
        end
        STOP: begin
          if (in == 1'b1) begin
            done <= 1'b1;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
          end
        end
        WAIT_STOP: begin
          // Wait here until in == 1 (stop bit detected)
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in == 1'b0) // Start bit detected
          next_state = START;
      end
      START: begin
        // One clock cycle to confirm start bit and start receiving data bits next cycle
        next_state = DATA;
      end
      DATA: begin
        if (bit_count == 3'd7) begin
          next_state = STOP;
        end
      end
      STOP: begin
        if (in == 1'b1) // correct stop bit
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end
      WAIT_STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule