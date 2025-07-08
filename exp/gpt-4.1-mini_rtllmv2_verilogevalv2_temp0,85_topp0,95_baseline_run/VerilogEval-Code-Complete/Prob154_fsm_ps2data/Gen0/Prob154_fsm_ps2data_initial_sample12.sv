module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  reg [1:0] byte_count;       // counts 0 to 3 bytes received
  reg [23:0] shift_reg;       // holds the 3 bytes

  always @(posedge clk) begin
    if (reset) begin
      byte_count <= 2'b00;
      done <= 1'b0;
      out_bytes <= 24'b0;
      shift_reg <= 24'b0;
    end else begin
      done <= 1'b0; // default done to 0

      if (byte_count == 2'b00) begin
        // Not in message, wait for byte with in[3]=1
        if (in[3]) begin
          // start message: first byte received
          shift_reg <= {in, 16'b0};
          byte_count <= 2'b01;
        end
      end else if (byte_count == 2'b01) begin
        // second byte
        shift_reg <= {shift_reg[15:0], in};
        byte_count <= 2'b10;
      end else if (byte_count == 2'b10) begin
        // third byte
        shift_reg <= {shift_reg[15:0], in};
        byte_count <= 2'b11;
      end else begin
        // byte_count == 3, message complete
        done <= 1'b1;
        out_bytes <= shift_reg; // output the 3-byte message

        // next cycle, go back to waiting for new message start
        byte_count <= 2'b00;
      end
    end
  end

endmodule