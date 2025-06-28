module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @ (posedge clk) begin
  if (a == 1'b1) begin
    if (q < 3'd6) // Counter should increment from 0 to 6
      q <= q + 1;
  end else if (a == 1'b0 && $rose(a)) begin
    q <= q; // Retain counter value when 'a' transitions from 1 to 0 until 'a' remains low
  end
end

endmodule