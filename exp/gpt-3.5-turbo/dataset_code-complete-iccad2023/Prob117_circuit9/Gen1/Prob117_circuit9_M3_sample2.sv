module TopModule(
  input clk, 
  input a, 
  output reg [2:0] q
);

always @(posedge clk) begin
  if (a && !q[0]) begin
    if (q < 3'd6) begin
      q <= q + 1;
    end
  end else if (!a) begin
    q <= 3'b0;
  end
end

endmodule