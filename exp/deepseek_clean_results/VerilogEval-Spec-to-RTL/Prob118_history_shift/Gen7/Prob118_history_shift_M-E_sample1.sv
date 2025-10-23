module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] current_history;
    reg [31:0] backup_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
            backup_history <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // Recover by combining pre-misprediction history with actual outcome
                current_history <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // Normal operation: shift in new prediction and backup current state
                backup_history <= current_history;
                current_history <= {current_history[30:0], predict_taken};
            end
            // No else - both registers retain their values
        end
    end

    assign predict_history = current_history;

endmodule