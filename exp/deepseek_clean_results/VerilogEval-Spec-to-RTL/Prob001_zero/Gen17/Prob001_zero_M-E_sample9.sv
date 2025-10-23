module TopModule(output zero);
reg zero_reg = 0;
always @(posedge clk) begin
    zero_reg <= zero_reg;  // Counter never increments
end
assign zero = zero_reg;
endmodule