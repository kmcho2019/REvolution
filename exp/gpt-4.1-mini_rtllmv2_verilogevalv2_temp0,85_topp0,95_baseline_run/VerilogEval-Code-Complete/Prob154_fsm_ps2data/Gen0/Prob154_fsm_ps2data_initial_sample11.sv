module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  reg [1:0] byte_count;       // counts from 0 to 3 (0 means waiting for first byte)
  reg [23:0] byte_buffer;

  always @(posedge clk) begin
    if (reset) begin
      byte_count <= 2'd0;
      byte_buffer <= 24'd0;
      done <= 1'b0;
      out_bytes <= 24'd0;
    end else begin
      done <= 1'b0; // default done deasserted
      
      if (byte_count == 2'd0) begin
        // Waiting for first byte with in[3]==1
        if (in[3]) begin
          // First byte received, store it in MSB and move to next byte
          byte_buffer <= {in, 16'd0};
          byte_count <= 2'd1;
        end
      end else if (byte_count == 2'd1) begin
        // Receiving second byte
        byte_buffer <= {byte_buffer[15:0], in};
        byte_count <= 2'd2;
      end else if (byte_count == 2'd2) begin
        // Receiving third byte
        byte_buffer <= {byte_buffer[15:0], in};
        byte_count <= 2'd3;
      end else if (byte_count == 2'd3) begin
        // Just finished receiving the third byte, signal done
        done <= 1'b1;
        out_bytes <= byte_buffer;
        // Prepare to wait for next message start byte
        byte_count <= 2'd0;
      end
    end
  end

endmodule