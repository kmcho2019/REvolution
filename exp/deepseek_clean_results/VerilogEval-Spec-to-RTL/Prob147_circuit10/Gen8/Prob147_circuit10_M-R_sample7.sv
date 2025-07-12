module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;  // Initialize state to 0

always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;  // Toggle state only when both a and b are 1
    end
end

assign q = state_reg ^ b;  // q is XOR of state and b
assign state = state_reg;

endmodule