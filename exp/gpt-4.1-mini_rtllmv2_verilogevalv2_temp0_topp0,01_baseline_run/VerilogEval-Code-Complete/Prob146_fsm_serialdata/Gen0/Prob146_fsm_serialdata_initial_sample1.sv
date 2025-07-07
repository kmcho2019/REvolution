module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // State encoding
  localparam IDLE    = 2'd0;
  localparam RECEIVE = 2'd1;
  localparam STOP    = 2'd2;

  reg [1:0] state, next_state;
  reg [2:0] bit_count; // counts 0 to 7 for 8 bits
  reg [7:0] data_reg;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      data_reg <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      done <= 1'b0; // default done low, only asserted for one cycle when valid byte received

      case (state)
        IDLE: begin
          bit_count <= 3'd0;
          data_reg <= 8'd0;
          if (in == 1'b0) begin
            // start bit detected, move to RECEIVE
            // next_state logic will handle this
          end
        end

        RECEIVE: begin
          // Shift in data bit LSB first
          data_reg <= {in, data_reg[7:1]};
          bit_count <= bit_count + 1'b1;
        end

        STOP: begin
          // Check stop bit
          if (in == 1'b1) begin
            // valid stop bit, output data and assert done
            out_byte <= data_reg;
            done <= 1'b1;
          end
          // else wait here until in == 1 to return to IDLE
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      IDLE: begin
        if (in == 1'b0)
          next_state = RECEIVE;
        else
          next_state = IDLE;
      end

      RECEIVE: begin
        if (bit_count == 3'd7)
          next_state = STOP;
        else
          next_state = RECEIVE;
      end

      STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = STOP;
      end

      default: next_state = IDLE;
    endcase
  end

endmodule