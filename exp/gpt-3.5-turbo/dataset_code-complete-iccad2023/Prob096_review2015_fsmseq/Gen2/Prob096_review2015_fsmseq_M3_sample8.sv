module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] last_four_bits;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    last_four_bits <= 4'b0;
    start_shifting <= 0;
  end
  else begin
    last_four_bits <= {last_four_bits[2:0], data};
    if (last_four_bits == 4'b1101) begin
      start_shifting <= 1;
    end
    else if (last_four_bits[3] == 1 && last_four_bits != 4'b1101) begin
      start_shifting <= 0;
    end
  end
end

endmodule