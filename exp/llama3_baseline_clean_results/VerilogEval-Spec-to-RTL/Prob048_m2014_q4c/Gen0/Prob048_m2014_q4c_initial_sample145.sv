module TopModule(
    input clk,
    input d,
    input r,
    output q
);

reg q_reg; // internal reg to hold the state of the flip flop
assign q = q_reg; // assign the output to the internal reg

always @(posedge clk) begin
    if (r) begin // if reset is high
        q_reg <= 0; // reset the flip flop to 0
    end else begin
        q_reg <= d; // otherwise, load the input value
    end
end

endmodule