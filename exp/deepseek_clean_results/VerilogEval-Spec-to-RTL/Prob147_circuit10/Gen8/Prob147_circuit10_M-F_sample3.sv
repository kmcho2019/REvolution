module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    if (a) begin
        if (b) begin
            state_reg <= ~state_reg;  // Toggle when a=1 and b=1
        end else begin
            state_reg <= 1'b0;        // Reset to 0 when a=1 and b=0
        end
    end
    // else: state remains unchanged
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule