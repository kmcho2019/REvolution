module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Reset to weakly not-taken state
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                if (state_reg == 2'b11) begin
                    state_reg <= 2'b11; // Saturate at maximum value
                end else begin
                    state_reg <= state_reg + 1'b1;
                end
            end else begin
                if (state_reg == 2'b00) begin
                    state_reg <= 2'b00; // Saturate at minimum value
                end else begin
                    state_reg <= state_reg - 1'b1;
                end
            end
        end else begin
            // No change when not training
            state_reg <= state_reg;
        end
    end
end

assign state = state_reg;

endmodule