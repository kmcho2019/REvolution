module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (~(a | b)) begin  // State updates when both inputs are low
        state_reg <= a ^ b;
    end
end

assign q = a ? (state_reg ^ b) : 1'b0;
assign state = state_reg;

endmodule