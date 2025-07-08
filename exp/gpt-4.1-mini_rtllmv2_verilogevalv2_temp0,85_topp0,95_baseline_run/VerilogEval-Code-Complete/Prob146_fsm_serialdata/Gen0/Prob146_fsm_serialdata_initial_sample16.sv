module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  typedef enum logic [1:0] {
    IDLE = 2'd0,
    DATA = 2'd1,
    STOP = 2'd2,
    WAIT_STOP = 2'd3
  } state_t;

  state_t state, next_state;
  reg [2:0] bit_cnt;
  reg [7:0] shift_reg;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_cnt <= 3'd0;
      shift_reg <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low, only asserted for one cycle in STOP state if stop bit correct

      case (state)
        IDLE: begin
          if (in == 1'b0) begin // start bit detected
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
          end
        end
        DATA: begin
          // shift in bit LSB first
          shift_reg <= {in, shift_reg[7:1]};
          bit_cnt <= bit_cnt + 1;
        end
        STOP: begin
          if (in == 1'b1) begin
            out_byte <= shift_reg;
            done <= 1'b1;
          end
        end
        WAIT_STOP: begin
          // nothing to do except wait for in == 1
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (in == 1'b0)
          next_state = DATA;
      end
      DATA: begin
        if (bit_cnt == 3'd7)
          next_state = STOP;
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
      end
    endcase
  end

endmodule