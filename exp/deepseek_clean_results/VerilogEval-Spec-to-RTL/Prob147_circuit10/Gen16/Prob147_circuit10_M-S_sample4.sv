module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    // Reset condition: a=b=1
    if (a & b) begin
        state_reg <= 1'b0;
    end
    // Toggle condition: a≠b
    else if (a ^ b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic
assign q = state_reg ^ b;
assign state = state_reg;

endmodule