module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state_reg <= 2'b01; // Reset to weakly not-taken state
    end else if (train_valid) begin
        if (train_taken && state_reg < 3) begin
            state_reg <= state_reg + 1; // Increment if not at max
        end else if (!train_taken && state_reg > 0) begin
            state_reg <= state_reg - 1; // Decrement if not at min
        end
    end
end

assign state = state_reg; // Output the current state

endmodule