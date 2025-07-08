module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  reg [1:0] count; // 0: searching, 1-3: bytes received

  always @(posedge clk) begin
    if (reset) begin
      count <= 0;
      out_bytes <= 24'b0;
      done <= 0;
    end else begin
      done <= 0; // default done low

      if (count == 0) begin
        // Waiting for first byte where in[3] == 1
        if (in[3]) begin
          count <= 1;
          out_bytes[23:16] <= in;
        end
      end else if (count == 1) begin
        out_bytes[15:8] <= in;
        count <= 2;
      end else if (count == 2) begin
        out_bytes[7:0] <= in;
        count <= 3;
      end else if (count == 3) begin
        // One cycle done signal after third byte
        done <= 1;
        count <= 0; // go back to searching for next message
      end
    end
  end

endmodule