module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // State encoding
  // 0 = waiting for first byte (with in[3] == 1)
  // 1 = collecting bytes 2 and 3
  reg state;
  reg [1:0] byte_count;  // counts 0..2 for bytes received in current message
  reg [23:0] msg_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= 0;
      byte_count <= 0;
      msg_reg <= 24'b0;
      out_bytes <= 24'b0;
      done <= 0;
    end else begin
      done <= 0; // default done to 0

      case (state)
        0: begin
          // Waiting for first byte with in[3] == 1
          if (in[3] == 1'b1) begin
            // Store first byte in highest 8 bits, reset count to 1
            msg_reg[23:16] <= in;
            byte_count <= 1;
            state <= 1;
          end
          // else remain in state 0, discarding bytes
        end

        1: begin
          // Collect bytes 2 and 3
          case (byte_count)
            1: begin
              // Store second byte in bits [15:8]
              msg_reg[15:8] <= in;
              byte_count <= 2;
            end
            2: begin
              // Store third byte in bits [7:0]
              msg_reg[7:0] <= in;
              done <= 1;
              out_bytes <= {msg_reg[23:16], msg_reg[15:8], in};
              // Go back to waiting state for next message
              state <= 0;
              byte_count <= 0;
            end
          endcase
        end

      endcase
    end
  end

endmodule