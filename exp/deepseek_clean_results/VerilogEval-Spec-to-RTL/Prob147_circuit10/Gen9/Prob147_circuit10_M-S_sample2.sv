module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a) begin
        state_reg <= ~state_reg;  // Toggle state whenever a=1
    end
end

assign q = state_reg ^ b;  // q is simply XOR of state and b
assign state = state_reg;

endmodule