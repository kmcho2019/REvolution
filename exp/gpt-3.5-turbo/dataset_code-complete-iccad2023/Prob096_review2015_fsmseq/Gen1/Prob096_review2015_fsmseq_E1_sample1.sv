module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [2:0] last_three_bits;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    last_three_bits <= 3'b0;
    start_shifting <= 0;
  end
  else begin
    last_three_bits <= {last_three_bits[1:0], data};
    if (last_three_bits == 3'b110) begin
      if (data == 1)
        start_shifting <= 1;
      else
        start_shifting <= 0;
    end
  end
end

endmodule