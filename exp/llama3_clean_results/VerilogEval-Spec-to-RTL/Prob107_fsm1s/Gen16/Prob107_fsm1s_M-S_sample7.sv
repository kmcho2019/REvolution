module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // State variable

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to state B
        out <= 1; // Output for state B
    end else begin
        if (~in && state) begin
            state <= 0; // Transition from A to B
            out <= 1; // Output for state B
        end else if (in && ~state) begin
            state <= 1; // Transition from B to A
            out <= 0; // Output for state A
        end
    end
end

endmodule