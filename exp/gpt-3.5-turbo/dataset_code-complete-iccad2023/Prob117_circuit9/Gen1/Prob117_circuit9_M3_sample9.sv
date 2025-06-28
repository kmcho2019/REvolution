module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @(posedge clk) begin
  if (a) begin
    if (q < 3'b111) // Counter should increment from 0 to 6
      q <= q + 1;
    else
      q <= 3'b0; // Reset counter to 0 when 'a' transitions from 1 to 0
  end
end

endmodule