module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // State encoding
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    RECEIVE = 2'b01,
    STOP = 2'b10
  } state_t;

  state_t state, next_state;
  reg [2:0] bit_cnt;
  reg [7:0] data_shift;

  // FSM sequential logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_cnt <= 3'd0;
      data_shift <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      done <= 1'b0; // default done to 0, assert only in STOP when valid stop bit

      case (state)
        IDLE: begin
          bit_cnt <= 3'd0;
          data_shift <= 8'd0;
          // wait for start bit (in == 0)
          // nothing else to update here
        end

        RECEIVE: begin
          // Shift in data bits, LSB first
          data_shift <= {in, data_shift[7:1]};
          bit_cnt <= bit_cnt + 1;
        end

        STOP: begin
          if (in == 1'b1) begin
            // Valid stop bit, output data and assert done
            out_byte <= data_shift;
            done <= 1'b1;
            bit_cnt <= 3'd0;
          end
          // else remain in STOP state until stop bit (in==1) is seen
        end
      endcase
    end
  end

  // FSM combinational next state logic
  always @(*) begin
    case (state)
      IDLE: begin
        if (in == 1'b0) // start bit detected
          next_state = RECEIVE;
        else
          next_state = IDLE;
      end

      RECEIVE: begin
        if (bit_cnt == 3'd7) // after receiving 8 data bits, go to STOP
          next_state = STOP;
        else
          next_state = RECEIVE;
      end

      STOP: begin
        if (in == 1'b1) // stop bit found, back to IDLE
          next_state = IDLE;
        else
          next_state = STOP;
      end

      default: next_state = IDLE;
    endcase
  end

endmodule