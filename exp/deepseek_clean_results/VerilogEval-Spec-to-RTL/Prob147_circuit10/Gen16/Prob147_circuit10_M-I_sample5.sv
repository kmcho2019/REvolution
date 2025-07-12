module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    // State toggles when a and b are different
    if (a ^ b) begin
        state_reg <= ~state_reg;
    end
end

// Comprehensive combinational logic for q
assign q = (state_reg & b) |        // Case 1: state=1 and b=1
           (~a & b) |               // Case 2: a=0 and b=1
           (~a & ~b & state_reg) |  // Case 3: a=0, b=0, state=1
           (a & ~b & ~state_reg);   // Case 4: a=1, b=0, state=0

assign state = state_reg;

endmodule