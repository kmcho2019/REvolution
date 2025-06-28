module PriorityEncoder (
  input [7:0] in,
  output reg [2:0] pos
);

integer i;
reg found_high;

always @* begin
  pos = 3'b0;
  found_high = 1'b0;
  
  for (i = 0; i < 8; i = i + 1) begin
    if (in[i] == 1'b1 && !found_high) begin
      pos = i;
      found_high = 1'b1;
    end
  end
end

endmodule