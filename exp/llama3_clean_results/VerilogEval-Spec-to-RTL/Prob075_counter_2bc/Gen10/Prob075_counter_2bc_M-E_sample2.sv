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
        state_reg <= 2'b01; // Initialize to TAKEN state
    end else begin
        case (state_reg)
            2'b00: // IDLE state
                if (train_valid && train_taken) begin
                    state_reg <= 2'b01; // Move to TAKEN state
                end else if (train_valid && !train_taken) begin
                    state_reg <= 2'b00; // Remain in IDLE state
                end else begin
                    state_reg <= 2'b00; // Remain in IDLE state
                end
            2'b01: // TAKEN state
                if (train_valid && train_taken) begin
                    state_reg <= 2'b10; // Move to TAKEN_TWICE state
                end else if (train_valid && !train_taken) begin
                    state_reg <= 2'b00; // Move to IDLE state
                end else begin
                    state_reg <= 2'b01; // Remain in TAKEN state
                end
            2'b10: // TAKEN_TWICE state
                if (train_valid && train_taken) begin
                    state_reg <= 2'b11; // Move to MAX_TAKEN state
                end else if (train_valid && !train_taken) begin
                    state_reg <= 2'b01; // Move to TAKEN state
                end else begin
                    state_reg <= 2'b10; // Remain in TAKEN_TWICE state
                end
            2'b11: // MAX_TAKEN state
                if (train_valid && train_taken) begin
                    state_reg <= 2'b11; // Remain in MAX_TAKEN state
                end else if (train_valid && !train_taken) begin
                    state_reg <= 2'b10; // Move to TAKEN_TWICE state
                end else begin
                    state_reg <= 2'b11; // Remain in MAX_TAKEN state
                end
            default: begin
                state_reg <= 2'b01; // Default to TAKEN state
            end
        endcase
    end
end

assign state = state_reg;

endmodule