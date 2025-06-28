module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

reg [7:0] d_flipflop[15:0];
reg [7:0] q_flipflop[15:0];

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    for (int i = 0; i < 16; i = i + 1) begin
      d_flipflop[i] <= 8'b0;
      q_flipflop[i] <= 8'b0;
    end
  end else begin
    for (int i = 0; i < 16; i = i + 1) begin
      if (byteena[1] && i >= 8) begin
        d_flipflop[i] <= d[i];
        q_flipflop[i] <= d_flipflop[i];
      end
      if (byteena[0] && i < 8) begin
        d_flipflop[i] <= d[i];
        q_flipflop[i] <= d_flipflop[i];
      end
    end
  end
end

always @* begin
  for (int i = 0; i < 16; i = i + 1) begin
    q[i] = q_flipflop[i];
  end
end

endmodule