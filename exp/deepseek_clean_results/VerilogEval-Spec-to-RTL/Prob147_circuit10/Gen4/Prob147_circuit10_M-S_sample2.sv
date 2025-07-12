module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a & b)
        state_reg <= ~state_reg;  // Toggle state only when both inputs are 1
end

assign q = state_reg ^ b;        // q is XOR of state and b
assign state = state_reg;

endmodule