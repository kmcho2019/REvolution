module TopModule (
  input clk,
  input d,
  output reg q
);

reg q1;
reg clk_divided;

always @ (posedge clk) begin
  clk_divided <= ~clk_divided; // Generate a divided clock signal
  if (clk_divided) // Alternate clock edges
    q1 <= d;
end

assign q = q1;

endmodule