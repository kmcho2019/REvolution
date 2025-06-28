module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : DFF_inst
      always @(posedge clk) begin
        if (reset) begin
          q[i] <= 1'b0;
        end else begin
          q[i] <= d[i];
        end
      end
    end
  endgenerate

endmodule