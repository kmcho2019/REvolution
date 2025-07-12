module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // internal register for the state
assign state = state_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Reset to weakly not-taken
    end else if (train_valid) begin
        if (train_taken && state_reg < 2'd3) begin
            state_reg <= state_reg + 1'b1; // Increment if train_taken and not at max
        end else if (!train_taken && state_reg > 2'd0) begin
            state_reg <= state_reg - 1'b1; // Decrement if not train_taken and not at min
        end
    end // else, state_reg keeps its value
end

endmodule