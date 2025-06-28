module TopModule (
  input clk,
  input slowena,
  input reset,
  output reg [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
  if (reset) begin
    count <= 4'b0000; // Reset counter to 0
  end else if (slowena) begin
    if (count == 4'b1001) begin
      count <= 4'b0000; // Reset counter to 0 after reaching 9
    end else begin
      count <= count + 4'b0001; // Increment counter
    end
  end
end

assign q = count;

endmodule