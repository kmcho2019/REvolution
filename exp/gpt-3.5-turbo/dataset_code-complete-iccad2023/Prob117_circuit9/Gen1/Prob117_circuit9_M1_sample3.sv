module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

// Initialize q to 0
always @ (posedge clk) begin
  if (a == 1) begin
    // Hold q value
  end else begin
    // Increment q
    if (q == 7) begin
      q <= 0;
    end else begin
      q <= q + 1;
    end
  end
end

endmodule