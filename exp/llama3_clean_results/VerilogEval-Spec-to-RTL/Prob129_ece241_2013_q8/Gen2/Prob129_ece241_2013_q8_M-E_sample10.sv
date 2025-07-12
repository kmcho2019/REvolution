module TopModule (
  input clk,
  input aresetn,
  input x,
  output z
);

reg [2:0] seq_reg; // shift register to hold the sequence

always @ (posedge clk or negedge aresetn) begin
  if (!aresetn) begin // async reset
    seq_reg <= 3'b000;
  end else begin
    seq_reg <= {seq_reg[1:0], x}; // shift in the new bit
  end
end

// output z is asserted when the sequence matches "101"
assign z = (seq_reg == 3'b101);

endmodule