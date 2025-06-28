module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

  reg [15:0] dff [15:0]; // 16 D flip-flops

  always @(posedge clk) begin
    if (resetn == 1'b0) begin // synchronous reset
      for (int i = 0; i < 16; i = i + 1) begin
        dff[i] <= 16'b0;
      end
    end else begin
      // Use a case statement to selectively write to the flip-flops based on the byte-enable signals
      case (byteena)
        2'b00: dff[7:0] <= d[7:0];
        2'b01: dff[15:8] <= d[15:8];
        default: begin
          dff[7:0] <= d[7:0];
          dff[15:8] <= d[15:8];
        end
      end
    end
  end

  assign q = dff;

endmodule