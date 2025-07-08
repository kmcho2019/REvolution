module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  typedef enum logic [1:0] {
    IDLE = 2'd0,
    RECEIVING = 2'd1,
    STOP = 2'd2,
    WAIT_STOP = 2'd3
  } state_t;

  state_t state, next_state;

  reg [2:0] bit_count;
  reg [7:0] data_reg;

  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      data_reg <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      case(state)
        IDLE: begin
          done <= 1'b0;
          bit_count <= 3'd0;
          if (in == 1'b0) begin
            // Start bit detected, prepare to receive data
            data_reg <= 8'd0;
          end
        end

        RECEIVING: begin
          done <= 1'b0;
          // Shift in the data bit (LSB first)
          data_reg <= {in, data_reg[7:1]};
          bit_count <= bit_count + 1;
        end

        STOP: begin
          if (in == 1'b1) begin
            // Correct stop bit received
            out_byte <= data_reg;
            done <= 1'b1;
          end else begin
            done <= 1'b0;
          end
        end

        WAIT_STOP: begin
          done <= 1'b0;
        end

        default: begin
          done <= 1'b0;
        end
      endcase
    end
  end

  // Next state combinational logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in == 1'b0)
          next_state = RECEIVING;
        else
          next_state = IDLE;
      end

      RECEIVING: begin
        if (bit_count == 3'd7)
          next_state = STOP;
        else
          next_state = RECEIVING;
      end

      STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end

      WAIT_STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end

      default: next_state = IDLE;
    endcase
  end

endmodule