module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg a_delayed;

always @(posedge clk) begin
  a_delayed <= a;
  if (a_delayed == 1 && a == 0) begin
    // Reset the counter to 0 when 'a' transitions from 1 to 0
    q <= 3'b0;
  end else begin
    // Increment the counter when 'a' transitions from 0 to 1
    if (a_delayed == 0 && a == 1) begin
      if (q < 3'b111)
        q <= q + 1;
    end
  end
end

endmodule