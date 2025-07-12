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
        state_reg <= ~state_reg;  // Toggle when both inputs are high
    end else if (~a & ~b) begin
        state_reg <= (state_reg == 0) ? 1 : state_reg;  // Set to 1 if currently 0
    end else if (a & ~b) begin
        state_reg <= (state_reg == 1) ? 0 : state_reg;  // Set to 0 if currently 1
    end
    // State remains unchanged when a=0 and b=1
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule