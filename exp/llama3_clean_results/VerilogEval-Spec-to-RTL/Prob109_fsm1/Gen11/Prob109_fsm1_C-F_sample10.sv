module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit register to hold the state
assign out = state; // Directly assign output as the current state to minimize switching activity

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Asynchronously reset to state B
    end else begin
        // Simplified state transition logic using ternary operator
        state <= (state == 1'b0) ? (in ? 1'b0 : 1'b1) : (in ? 1'b1 : 1'b0);
    end
end

endmodule