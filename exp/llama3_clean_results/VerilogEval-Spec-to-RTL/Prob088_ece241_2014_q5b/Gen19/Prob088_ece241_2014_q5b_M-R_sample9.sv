module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1) and state B (0)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state A
    end else begin
        state <= (state && ~x) || (~state); // Simplified state transition
    end
end

assign z = (state) ? x : ~x; // Output generation using assign

endmodule