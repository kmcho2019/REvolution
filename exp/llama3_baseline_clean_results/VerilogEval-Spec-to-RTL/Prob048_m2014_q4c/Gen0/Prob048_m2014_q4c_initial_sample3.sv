module TopModule(
    input clk,
    input d,
    input r,
    output q
);

reg q_reg;  // internal reg to hold the output value
assign q = q_reg;  // assign the output to the internal reg

always @(posedge clk) begin
    if (r) begin
        q_reg <= 0;  // reset the output to 0 if reset is high
    end else begin
        q_reg <= d;  // update the output with the data input if reset is low
    end
end

endmodule