module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

reg [7:0] q_temp;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q_temp <= 8'b0;
  end else begin
    for (int i = 0; i < 8; i = i + 1) begin
      if (i == 0) begin
        q_temp[0] <= d[0];
      end else if (i == 1) begin
        q_temp[1] <= d[1];
      end else if (i == 2) begin
        q_temp[2] <= d[2];
      end else if (i == 3) begin
        q_temp[3] <= d[3];
      end else if (i == 4) begin
        q_temp[4] <= d[4];
      end else if (i == 5) begin
        q_temp[5] <= d[5];
      end else if (i == 6) begin
        q_temp[6] <= d[6];
      end else if (i == 7) begin
        q_temp[7] <= d[7];
      end
    end
  end
end

always @(posedge clk) begin
  q <= q_temp;
end

endmodule