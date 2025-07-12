module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;  // Toggle when both a and b are 1
    end
end

assign q = ~(b ^ state_reg);  // XNOR operation
assign state = state_reg;

endmodule