module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

reg [7:0] in_reg, prev_in;

always @(posedge clk) begin
  // Store the current input values
  in_reg <= in;
  
  // Detect transition for each bit
  for (int bit_num=0; bit_num<8; bit_num=bit_num+1) begin
    if (in_reg[bit_num] && !prev_in[bit_num]) begin
      pedge[bit_num] <= 1;
    end else begin
      pedge[bit_num] <= 0;
    end
  end
  
  // Store the current input as previous for the next cycle
  prev_in <= in_reg;
end

endmodule