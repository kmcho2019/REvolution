module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // States encoding
  typedef enum reg [1:0] {
    IDLE = 2'b00,
    DATA = 2'b01,
    STOP = 2'b10,
    WAIT_STOP = 2'b11
  } state_t;

  reg [2:0] bit_count; // count bits 0 to 7
  reg [7:0] data_reg;  // store received data (not used for output here)
  reg [1:0] state, next_state;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      data_reg <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low

      case (state)
        IDLE: begin
          bit_count <= 3'd0;
          data_reg <= 8'd0;
          if (in == 1'b0) // start bit detected
            next_state <= DATA;
          else
            next_state <= IDLE;
        end

        DATA: begin
          data_reg <= {in, data_reg[7:1]}; // shift in bit LSB first
          bit_count <= bit_count + 1;
          if (bit_count == 3'd7)
            next_state <= STOP;
          else
            next_state <= DATA;
        end

        STOP: begin
          if (in == 1'b1) begin
            done <= 1'b1; // byte correctly received
            next_state <= IDLE;
          end else begin
            next_state <= WAIT_STOP;
          end
        end

        WAIT_STOP: begin
          if (in == 1'b1)
            next_state <= IDLE;
          else
            next_state <= WAIT_STOP;
        end
      endcase
    end
  end

endmodule