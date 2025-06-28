module TopModule (
  input clk,
  input [7:0] d,
  output reg [7:0] q
);

reg [7:0] q_next;

always @(posedge clk) begin
  q <= q_next;
end

genvar i;
generate
  for (i = 0; i < 8; i = i + 1) begin : DFF_INST
    always @* begin
      q_next[i] = d[i];
    end
  end
endgenerate

endmodule