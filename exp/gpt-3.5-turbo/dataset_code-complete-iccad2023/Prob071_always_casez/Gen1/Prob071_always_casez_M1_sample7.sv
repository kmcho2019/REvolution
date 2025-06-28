module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*)
begin
  pos = 3'b0; // Initialize output to 0
  reg found;

  found = 1'b0;
  for (int i = 0; i < 8; i=i+1) begin
    if ((in[i] == 1) && (found == 1'b0)) begin
      pos = i;
      found = 1'b1;
    end
  end
end

endmodule