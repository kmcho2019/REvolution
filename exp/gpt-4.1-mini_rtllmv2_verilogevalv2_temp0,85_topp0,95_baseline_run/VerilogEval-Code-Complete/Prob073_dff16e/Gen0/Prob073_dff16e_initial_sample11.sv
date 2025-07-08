module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

  always @(posedge clk) begin
    if (!resetn) begin
      q <= 16'b0;
    end else begin
      // update upper byte if byteena[1] is set
      if (byteena[1])
        q[15:8] <= d[15:8];
      // keep upper byte unchanged if byteena[1] is 0

      // update lower byte if byteena[0] is set
      if (byteena[0])
        q[7:0] <= d[7:0];
      // keep lower byte unchanged if byteena[0] is 0
    end
  end

endmodule