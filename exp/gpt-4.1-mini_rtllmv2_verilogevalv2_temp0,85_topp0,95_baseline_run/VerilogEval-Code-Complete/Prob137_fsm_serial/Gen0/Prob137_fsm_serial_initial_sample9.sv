module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // State encoding
  localparam IDLE     = 2'd0;
  localparam RECEIVING= 2'd1;
  localparam STOP_BIT = 2'd2;
  localparam WAIT_STOP= 2'd3;

  reg [1:0] state, next_state;
  reg [3:0] bit_count;      // To count 8 data bits
  reg [7:0] data_reg;       // To hold received data (optional, here just for completeness)

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      data_reg <= 0;
      done <= 0;
    end else begin
      done <= 0; // Default done low, asserted only one cycle on successful byte

      case(state)
        IDLE: begin
          bit_count <= 0;
          data_reg <= 0;
          if (in == 1'b0) // start bit detected
            state <= RECEIVING;
          else
            state <= IDLE;
        end

        RECEIVING: begin
          data_reg <= {in, data_reg[7:1]}; // shift in LSB first, so MSB side gets new bit
          bit_count <= bit_count + 1;
          if (bit_count == 7) // after receiving 8 bits (0 to 7)
            state <= STOP_BIT;
          else
            state <= RECEIVING;
        end

        STOP_BIT: begin
          if (in == 1'b1) begin
            done <= 1'b1;  // byte correctly received
            state <= IDLE;
          end else begin
            // Stop bit incorrect, enter wait stop state
            state <= WAIT_STOP;
          end
        end

        WAIT_STOP: begin
          if (in == 1'b1) begin
            // Found stop bit, return to IDLE to look for next byte
            state <= IDLE;
          end else begin
            state <= WAIT_STOP;
          end
        end

        default: state <= IDLE;

      endcase
    end
  end

endmodule