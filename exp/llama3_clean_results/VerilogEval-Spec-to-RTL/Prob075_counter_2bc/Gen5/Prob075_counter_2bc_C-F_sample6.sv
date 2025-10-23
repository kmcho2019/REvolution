module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
assign state = state_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else if (train_valid) begin
        if (train_taken) begin
            state_reg <= (state_reg == 2'b11) ? 2'b11 : state_reg + 1'b1; // Increment with saturation
        end else begin
            state_reg <= (state_reg == 2'b00) ? 2'b00 : state_reg - 1'b1; // Decrement with saturation
        end
    end else begin
        // When train_valid is low, stay in the current state
        state_reg <= state_reg;
    end
end

endmodule