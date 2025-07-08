module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);
  // State: count of bytes received in current message (0 to 3)
  reg [1:0] count;

  always @(posedge clk) begin
    if (reset) begin
      count <= 0;
      out_bytes <= 24'bx;
      done <= 0;
    end else begin
      done <= 0; // default no done each cycle

      if (count == 0) begin
        // waiting for start byte with in[3] = 1
        if (in[3] == 1'b1) begin
          count <= 1;
          out_bytes[23:16] <= in; // first byte
        end
      end else if (count == 1) begin
        count <= 2;
        out_bytes[15:8] <= in; // second byte
      end else if (count == 2) begin
        count <= 3;
        out_bytes[7:0] <= in; // third byte
      end else if (count == 3) begin
        // done signal one cycle after third byte received
        done <= 1;
        count <= 0;
      end
    end
  end
endmodule