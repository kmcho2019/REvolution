module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

reg [7:0] q_temp;

always @(negedge clk or posedge reset) begin
  if (reset) begin
    q_temp <= 8'b00110100;
  end else begin
    for (int i=0; i<8; i=i+1) begin
      if (i == 0) begin
        q_temp[0] <= d[0];
      end else begin
        q_temp[i] <= q_temp[i-1];
      end
    end
  end
end

assign q = q_temp;

endmodule