module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;  // Initialize to 0
reg q_reg = 1'b0;      // Initialize output

always @(posedge clk) begin
    // State transition logic
    if (a & b) begin
        state_reg <= ~state_reg;  // Toggle state when both inputs are 1
    end
    // Otherwise state remains unchanged

    // Output logic
    if (a) begin
        q_reg <= state_reg ^ b;   // XOR when a=1 (except a=1,b=1 case)
    end
    // When a=0, q maintains its value (implicit else)
end

assign q = q_reg;
assign state = state_reg;

endmodule