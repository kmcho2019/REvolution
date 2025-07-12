module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Single-bit state register (0=A, 1=B)
    reg state;

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Async reset to state B
        end else begin
            state <= ~(state ^ in);  // Optimized next-state logic
        end
    end

    // Output is the state bit (Moore machine)
    assign out = state;

endmodule