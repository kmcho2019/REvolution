module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    if (b) begin
        // When b=1, state becomes equal to a
        state_reg <= a;
    end else if (a) begin
        // When b=0 and a=1, toggle state
        state_reg <= ~state_reg;
    end
    // Otherwise state remains unchanged
end

// Refined combinational logic for q
assign q = (state_reg & ~b & ~a) |  // q=1 when state=1, b=0, a=0
           (~a & b) |              // or when a=0 and b=1
           (state_reg & ~b & a);    // or when state=1, b=0, a=1 (toggle case)

assign state = state_reg;

endmodule