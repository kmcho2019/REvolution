module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    // State updates to a only when b is 1
    if (b) begin
        state_reg <= a;
    end
end

// Simplified combinational logic for q
assign q = (state_reg & ~b) |  // q=1 when state=1 and b=0
           (~a & b);          // or when a=0 and b=1

assign state = state_reg;

endmodule