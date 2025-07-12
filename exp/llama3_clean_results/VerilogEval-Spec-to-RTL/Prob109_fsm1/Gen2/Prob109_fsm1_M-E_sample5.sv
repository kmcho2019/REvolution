module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal representing the counter value
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        // Toggle state when transitioning from A to B (in == 0) or from B to A (in == 0)
        if (~in) begin
            state <= ~state; // Toggle state
        end
    end
end

// Out is directly derived from the state in this implementation
assign out = state;

endmodule