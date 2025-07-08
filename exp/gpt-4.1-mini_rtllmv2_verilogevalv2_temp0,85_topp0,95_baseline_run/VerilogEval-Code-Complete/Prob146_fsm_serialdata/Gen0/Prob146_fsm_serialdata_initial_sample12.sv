module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // State encoding
  localparam IDLE = 2'd0;
  localparam DATA = 2'd1;
  localparam STOP = 2'd2;

  reg [1:0] state, next_state;
  reg [2:0] bit_count;       // count 0 to 7 for 8 bits
  reg [7:0] data_shift;      // shift register for data bits

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      data_shift <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      done <= 1'b0; // default done low; only asserted in STOP on correct stop bit

      case(state)
        IDLE: begin
          bit_count <= 3'd0;
          data_shift <= 8'd0;
          if (in == 1'b0) begin
            // Detected start bit, prepare to receive data
            next_state <= DATA;
          end else begin
            next_state <= IDLE;
          end
        end

        DATA: begin
          // Shift in data bits LSB first
          data_shift <= {in, data_shift[7:1]};
          bit_count <= bit_count + 3'd1;
          if (bit_count == 3'd7) begin
            next_state <= STOP;
          end else begin
            next_state <= DATA;
          end
        end

        STOP: begin
          if (in == 1'b1) begin
            // Correct stop bit
            out_byte <= data_shift;
            done <= 1'b1;
            next_state <= IDLE;
          end else begin
            // Wait here until stop bit is detected
            next_state <= STOP;
          end
        end

        default: next_state <= IDLE;

      endcase
    end
  end

endmodule