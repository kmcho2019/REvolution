module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

// Initialize q to 4
always @ (posedge clk) begin
  if (a == 0) begin
    if (q == 7) begin
      q <= 0;
    end else begin
      q <= q + 1;
    end
  end else begin
    if (a === 1'b1 && $past(a) === 1'b0) begin
      q <= 4;
    end
  end
end

endmodule