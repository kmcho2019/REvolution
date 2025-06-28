module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

  reg [7:0] q_temp;

  always @(posedge clk) begin
    if(reset) begin
      q_temp <= 8'h34;
    end
    else begin
      for (int i = 0; i < 8; i = i + 1) begin
        if (i == 0) begin
          q_temp[i] <= d[i];
        end
        else begin
          q_temp[i] <= q_temp[i-1];
        end
      end
    end
  end

  always @(negedge clk) begin
    q <= q_temp;
  end

endmodule