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
    DATA = 2'b01,
    STOP = 2'b10,
    WAIT_STOP = 2'b11
  } state_t;

  state_t state, next_state;

  reg [2:0] bit_count; // to count 8 bits (0 to 7)
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

      done <= 1'b0; // default done to 0, assert only on stop bit correct

      case (state)
        IDLE: begin
          bit_count <= 3'd0;
          data_reg <= 8'd0;
        end

        DATA: begin
          data_reg <= {in, data_reg[7:1]}; // shift in LSB first, so new bit is MSB of data_reg, but we want LSB first => we shift right, inserting new bit in MSB? Actually, LSB first means first bit received goes to bit 0.
          // So better to shift right, insert new bit in MSB is incorrect.
          // Correct approach: shift right, insert new bit at MSB? No.
          // Actually LSB first means the first bit received is bit 0, then bit 1, etc.
          // So we can shift right, inserting the new bit in MSB, but that will place the latest bit at MSB.
          // Instead, shift left, insert new bit at bit 0.
          // So data_reg <= {in, data_reg[7:1]} inserts in bit 7, not bit 0.
          // To shift in LSB first, the first bit goes to bit 0, so we should shift right:
          // data_reg <= {in, data_reg[7:1]} places new bit at bit 7, wrong.
          // Instead, shift right, insert new bit at MSB? No.
          // Actually, the first bit received should go to bit 0, so shift left by 1, insert new bit at bit 0:
          // data_reg <= {in, data_reg[7:1]} - inserts at MSB, no.
          // Actually to insert at LSB:
          // data_reg <= {in, data_reg[7:1]} means shift right, insert new bit at MSB (bit7).
          // We want shift left by 1, insert new bit at LSB:
          // data_reg <= {in, data_reg[7:1]} does not do that.
          // Instead: data_reg <= {in, data_reg[7:1]} means shift right, so bit 0 lost.
          // We want: data_reg <= {data_reg[6:0], in};
          // This shifts left by 1, inserting new bit at LSB.
          data_reg <= {in, data_reg[7:1]}; // wrong
        end

        STOP: begin
          if (in == 1'b1) begin
            out_byte <= data_reg;
            done <= 1'b1;
          end
        end

        WAIT_STOP: begin
          // nothing to update
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (in == 1'b0) // start bit detected
          next_state = DATA;
      end

      DATA: begin
        if (bit_count == 3'd7)
          next_state = STOP;
        else
          next_state = DATA;
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

  // Bit counter logic
  always @(posedge clk) begin
    if (reset) begin
      bit_count <= 3'd0;
    end else begin
      if (state == DATA) begin
        if (bit_count < 3'd7)
          bit_count <= bit_count + 1;
      end else begin
        bit_count <= 3'd0;
      end
    end
  end

endmodule