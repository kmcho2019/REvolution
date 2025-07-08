module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // State encoding
  localparam IDLE = 2'd0;
  localparam BYTE1 = 2'd1;
  localparam BYTE2 = 2'd2;
  localparam BYTE3 = 2'd3;

  reg [1:0] state, next_state;
  reg [23:0] message_reg, next_message_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      message_reg <= 24'b0;
      done <= 1'b0;
      out_bytes <= 24'b0;
    end else begin
      state <= next_state;
      message_reg <= next_message_reg;
      done <= 1'b0; // default done low unless set below

      if (next_state == BYTE3) begin
        // After receiving the third byte, output done next cycle
        done <= 1'b1;
        out_bytes <= next_message_reg;
      end
    end
  end

  always @* begin
    next_state = state;
    next_message_reg = message_reg;

    case(state)
      IDLE: begin
        done = 1'b0;
        if (in[3] == 1'b1) begin
          // Found first byte of message
          next_message_reg = {in, 16'b0}; // store byte 1 in bits [23:16]
          next_state = BYTE1;
        end
      end

      BYTE1: begin
        // Store second byte in bits [15:8]
        next_message_reg = {message_reg[23:8], in};
        next_state = BYTE2;
      end

      BYTE2: begin
        // Store third byte in bits [7:0]
        next_message_reg = {message_reg[23:0], 8'b0}; // shift left 8 bits
        next_message_reg = {message_reg[23:8], in}; // overwrite low byte with new byte
        next_state = BYTE3;
      end

      BYTE3: begin
        // done asserted in next clock cycle, after this we return to IDLE
        next_state = IDLE;
      end

      default: begin
        next_state = IDLE;
        next_message_reg = 24'b0;
      end
    endcase
  end

endmodule