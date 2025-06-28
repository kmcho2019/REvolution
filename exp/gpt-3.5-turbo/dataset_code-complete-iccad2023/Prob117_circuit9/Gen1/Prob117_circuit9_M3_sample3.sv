module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @ (posedge clk) begin
  if (a) begin
    if (q != 3'd6)
      q <= q + 1;
    else
      q <= 3'b0;
  end else if (~a && (q != 3'b0)) begin
    q <= 3'b0;
  end
end

endmodule