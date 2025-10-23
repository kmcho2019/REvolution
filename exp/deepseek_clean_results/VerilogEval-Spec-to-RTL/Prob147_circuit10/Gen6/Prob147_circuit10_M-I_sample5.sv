module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State toggles only when a=1 and b=1
always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic:
// a=0: pass through b
// a=1: q = !(state ^ b)
assign q = a ? ~(state_reg ^ b) : b;
assign state = state_reg;

endmodule