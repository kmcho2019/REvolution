module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);
  // FSM states
  typedef enum reg [1:0] {
    IDLE = 2'b00,
    RECEIVE = 2'b01,
    STOP_CHECK = 2'b10,
    WAIT_STOP = 2'b11
  } state_t;

  state_t state, next_state;
  reg [2:0] bit_count;   // counts from 0 to 7 for 8 data bits
  reg [7:0] shift_reg;   // holds received bits

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      shift_reg <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      done <= 1'b0;  // default done low
      
      case(state)
        IDLE: begin
          if (in == 1'b0) begin // Start bit detected
            state <= RECEIVE;
            bit_count <= 3'd0;
          end
        end

        RECEIVE: begin
          // Shift in bit LSB first
          shift_reg <= {in, shift_reg[7:1]};
          if (bit_count == 3'd7) begin
            state <= STOP_CHECK;
          end
          bit_count <= bit_count + 3'd1;
        end

        STOP_CHECK: begin
          if (in == 1'b1) begin
            // Stop bit correct
            out_byte <= shift_reg;
            done <= 1'b1;
            state <= IDLE;
          end else begin
            // Stop bit incorrect, must wait for stop bit
            state <= WAIT_STOP;
          end
        end

        WAIT_STOP: begin
          if (in == 1'b1) begin
            // Found stop bit, now can accept next start bit
            state <= IDLE;
          end
        end
      endcase
    end
  end

endmodule