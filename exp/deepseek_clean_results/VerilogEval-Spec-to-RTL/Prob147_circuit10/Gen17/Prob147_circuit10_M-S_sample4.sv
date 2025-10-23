module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    if (a == 0 && b == 0) begin
        state_reg <= 1'b0;
    end
    else if (a & b) begin
        state_reg <= ~state_reg;
    end
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule