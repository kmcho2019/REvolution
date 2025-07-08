module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  reg [1:0] byte_count; // counts 0,1,2 for bytes received

  always @(posedge clk) begin
    if (reset) begin
      byte_count <= 2'b00;
      out_bytes <= 24'b0;
      done <= 1'b0;
    end else begin
      done <= 1'b0; // default done low

      if (byte_count == 2'b00) begin
        // Waiting for first byte with in[3] == 1
        if (in[3]) begin
          // capture first byte
          out_bytes[23:16] <= in;
          byte_count <= 2'b01;
        end
      end else if (byte_count == 2'b01) begin
        // Capture second byte
        out_bytes[15:8] <= in;
        byte_count <= 2'b10;
      end else if (byte_count == 2'b10) begin
        // Capture third byte
        out_bytes[7:0] <= in;
        done <= 1'b1; // signal done this cycle
        byte_count <= 2'b00; // reset to search for next message
      end
    end
  end

endmodule