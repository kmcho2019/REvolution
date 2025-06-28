module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

reg [6:0] last_bits;

always @ (posedge clk or posedge reset)
begin
  if (reset) begin
    last_bits <= 7'b0000000;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  else begin
    last_bits <= {last_bits[5:0], in};
    disc <= (last_bits == 7'b0111110);
    flag <= (last_bits == 7'b01111110);
    err <= (last_bits[6:1] == 6'b111111);
  end
end

endmodule