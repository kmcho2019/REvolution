module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // State encoding
  typedef enum reg [1:0] {
    IDLE = 2'b00,
    RECEIVE = 2'b01,
    STOP = 2'b10,
    WAIT_STOP = 2'b11
  } state_t;

  state_t state, next_state;

  reg [7:0] data_reg;
  reg [2:0] bit_cnt;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      data_reg <= 8'b0;
      bit_cnt <= 3'b0;
      out_byte <= 8'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0;  // default no done pulse
      case(state)
        IDLE: begin
          // wait for start bit (0)
          if (in == 1'b0) begin
            bit_cnt <= 3'b0;
            data_reg <= 8'b0;
          end
        end
        RECEIVE: begin
          // shift in data bits LSB first
          data_reg <= {in, data_reg[7:1]};
          bit_cnt <= bit_cnt + 1'b1;
        end
        STOP: begin
          // done pulse if stop bit correct
          if (in == 1'b1) begin
            done <= 1'b1;
            out_byte <= data_reg;
          end
        end
        WAIT_STOP: begin
          // no change to data_reg or bit_cnt
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in == 1'b0) // start bit detected
          next_state = RECEIVE;
      end
      RECEIVE: begin
        if (bit_cnt == 3'd7)
          next_state = STOP;
        else
          next_state = RECEIVE;
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
    endcase
  end

endmodule