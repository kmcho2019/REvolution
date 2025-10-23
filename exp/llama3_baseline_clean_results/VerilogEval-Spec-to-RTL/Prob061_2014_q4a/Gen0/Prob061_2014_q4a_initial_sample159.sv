module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        // Load the value R when L is asserted
        Q <= R;
    end else if (E) begin
        // Shift the value from the previous stage (w) when E is enabled and L is not asserted
        Q <= w;
    end else begin
        // Maintain the current state when E is not enabled
        // No need to do anything here since Q is already set to its current value
    end
end

endmodule