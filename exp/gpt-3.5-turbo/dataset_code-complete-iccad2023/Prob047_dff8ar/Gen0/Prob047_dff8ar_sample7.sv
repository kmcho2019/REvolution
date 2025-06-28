module TopModule (
  input clk,
  input [7:0] d,
  input areset,
  output reg [7:0] q
);

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      q <= 8'b0;
    end else begin
      for (int i=0; i<8; i=i+1) begin
        if (i == 0) begin
          if (d[i] == 1) begin
            q[i] <= 1'b1;
          end else begin
            q[i] <= 1'b0;
          end
        end else begin
          if (d[i] == 1) begin
            q[i] <= q[i-1];
          end else begin
            q[i] <= ~q[i-1];
          end
        end
      end
    end
  end

endmodule