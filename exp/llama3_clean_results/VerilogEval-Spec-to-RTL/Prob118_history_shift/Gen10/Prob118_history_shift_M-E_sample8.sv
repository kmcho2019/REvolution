module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

reg [1:0] state;
reg [31:0] next_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset state
        predict_history <= 32'd0;
    end else begin
        case(state)
            2'b00: begin // Idle state
                if (train_mispredicted) begin
                    state <= 2'b01; // Transition to load history state
                    predict_history <= {train_history, train_taken};
                end else if (predict_valid) begin
                    state <= 2'b10; // Transition to shift history state
                    predict_history <= {predict_history[30:0], predict_taken};
                end
            end
            2'b01: begin // Load history state
                state <= 2'b00; // Transition back to idle state
            end
            2'b10: begin // Shift history state
                state <= 2'b00; // Transition back to idle state
            end
            default: begin
                state <= 2'b00; // Default to idle state
            end
        endcase
    end
end

endmodule