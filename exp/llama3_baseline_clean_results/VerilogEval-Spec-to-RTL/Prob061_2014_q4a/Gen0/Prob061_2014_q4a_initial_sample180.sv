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
        // Load the value R into the current stage
        Q <= R;
    end else if (E) begin
        // Shift the input w from the previous stage into the current stage
        Q <= w;
    end else begin
        // If neither load nor shift is enabled, keep the current value
        Q <= Q;
    end
end

endmodule