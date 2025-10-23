module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State update logic - only toggles on a=1,b=1
always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic:
// - When a=0: output b
// - When a=1: output state
assign q = a ? state_reg : b;
assign state = state_reg;

endmodule