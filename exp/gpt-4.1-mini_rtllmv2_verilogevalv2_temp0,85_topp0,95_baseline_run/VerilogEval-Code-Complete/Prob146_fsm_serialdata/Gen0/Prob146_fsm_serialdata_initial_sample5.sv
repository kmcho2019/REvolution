module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // FSM states
  localparam IDLE      = 2'd0;
  localparam DATA      = 2'd1;
  localparam STOP_WAIT = 2'd2;

  reg [1:0] state, next_state;
  reg [2:0] bit_count;      // counts data bits received (0-7)
  reg [7:0] data_reg;       // stores received data byte

  // FSM state transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      data_reg <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      done <= 1'b0; // default no done assertion
      case (state)
        IDLE: begin
          // Wait for start bit (0)
          if (in == 1'b0) begin
            // Start bit detected, go to DATA to receive bits
            state <= DATA;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
          end else begin
            // Stay in IDLE
            state <= IDLE;
          end
        end

        DATA: begin
          // Shift in data bit (LSB first, so shift left and insert at LSB)
          data_reg <= {in, data_reg[7:1]};
          if (bit_count == 3'd7) begin
            // All 8 data bits received, go to STOP_WAIT
            state <= STOP_WAIT;
          end else begin
            bit_count <= bit_count + 1;
            state <= DATA;
          end
        end

        STOP_WAIT: begin
          if (in == 1'b1) begin
            // Correct stop bit received, output data and done
            out_byte <= data_reg;
            done <= 1'b1;
            // Go back to IDLE waiting for next start bit
            state <= IDLE;
          end else begin
            // Wait here until stop bit seen
            state <= STOP_WAIT;
          end
        end

        default: begin
          state <= IDLE;
        end
      endcase
    end
  end

endmodule