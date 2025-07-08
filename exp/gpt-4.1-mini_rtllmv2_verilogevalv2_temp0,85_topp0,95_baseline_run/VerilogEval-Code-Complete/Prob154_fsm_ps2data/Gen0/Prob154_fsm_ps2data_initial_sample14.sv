module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  reg [1:0] byte_count;

  always @(posedge clk) begin
    done <= 1'b0; // default no done

    if (reset) begin
      byte_count <= 2'b00;
      out_bytes <= 24'b0;
    end else begin
      case (byte_count)
        2'b00: begin
          // Waiting for first byte with in[3] == 1
          if (in[3]) begin
            out_bytes[23:16] <= in;
            byte_count <= 2'b01;
          end
        end

        2'b01: begin
          // Store second byte
          out_bytes[15:8] <= in;
          byte_count <= 2'b10;
        end

        2'b10: begin
          // Store third byte
          out_bytes[7:0] <= in;
          byte_count <= 2'b00;
          done <= 1'b1; // done asserted immediately after third byte received
        end

        default: begin
          byte_count <= 2'b00; // Safety default
        end
      endcase
    end
  end

endmodule