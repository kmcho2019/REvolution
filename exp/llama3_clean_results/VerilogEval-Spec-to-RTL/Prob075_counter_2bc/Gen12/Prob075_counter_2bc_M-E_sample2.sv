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
        state_reg <= 2'b01; // Initialize to 1
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                state_reg <= (state_reg == 2'b11) ? 2'b11 : state_reg + 1; // Increment with saturation
            end else begin
                state_reg <= (state_reg == 2'b00) ? 2'b00 : state_reg - 1; // Decrement with saturation
            end
        end else begin
            state_reg <= state_reg; // Remain unchanged
        end
    end
end

assign state = state_reg;

endmodule