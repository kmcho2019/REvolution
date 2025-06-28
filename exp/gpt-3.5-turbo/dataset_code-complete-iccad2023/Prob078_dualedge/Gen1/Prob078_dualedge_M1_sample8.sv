module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_reg;

always @ (posedge clk or negedge clk) begin
  q_reg <= d; // Store the input on both rising and falling edges
end

assign q = q_reg; // Output the stored value

endmodule