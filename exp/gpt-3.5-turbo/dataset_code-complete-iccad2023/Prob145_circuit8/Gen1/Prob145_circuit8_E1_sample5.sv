module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg [1:0] count; // 2-bit counter

always @(posedge clock) begin
  if (a) begin
    if (count < 2) begin
      count <= count + 1;
      q <= 0;
    end
  end
  else begin
    count <= 0;
    q <= 1;
  end
end

assign p = (count == 2) ? 1 : 0;

endmodule