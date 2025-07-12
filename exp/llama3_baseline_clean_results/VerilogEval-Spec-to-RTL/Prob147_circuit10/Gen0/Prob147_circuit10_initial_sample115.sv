module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg; // internal state register
assign state = state_reg;

always @(posedge clk) begin
    if (a == 1'b1 && b == 1'b1) begin
        state_reg <= ~state_reg; // toggle state when a = 1 and b = 1
    end else if (a == 1'b0 && b == 1'b1) begin
        state_reg <= state_reg; // state remains the same when a = 0 and b = 1
    end else begin
        state_reg <= state_reg; // state remains the same for other cases
    end
end

assign q = (b == 1'b1 && (state_reg == 1'b0 || a == 1'b0)) ? 1'b1 : 1'b0;

endmodule