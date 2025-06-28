module TopModule (
  input clk,
  input a,
  input b,
  output reg [1:0] state,
  output reg [1:0] q
);

reg [1:0] count;

always @(posedge clk) begin
  if (a == 1'b1 && b == 1'b0) // Up count
    count <= count + 1;
  else if (a == 1'b0 && b == 1'b1) // Down count
    count <= count - 1;
  
  state <= {count[1] ^ count[0], count[1]};
  q <= count;
end

endmodule