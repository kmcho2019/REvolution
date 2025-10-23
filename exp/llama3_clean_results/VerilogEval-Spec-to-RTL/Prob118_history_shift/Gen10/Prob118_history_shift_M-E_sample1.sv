module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

reg [31:0] history;
reg [1:0] state; // 0: idle, 1: update due to prediction, 2: update due to misprediction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        history <= 32'd0;
    end else begin
        case (state)
            0: begin // Idle state
                if (train_mispredicted) begin
                    state <= 2; // Transition to update due to misprediction
                end else if (predict_valid) begin
                    state <= 1; // Transition to update due to prediction
                end
            end
            1: begin // Update due to prediction
                history <= {history[30:0], predict_taken};
                state <= 0; // Back to idle
            end
            2: begin // Update due to misprediction
                history <= {train_history, train_taken};
                state <= 0; // Back to idle
            end
        endcase
    end
end

assign predict_history = history;

endmodule