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
    reg [31:0] speculative_history;

    // Output the speculative history for predictions
    assign predict_history = speculative_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
            speculative_history <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // Rollback: use train_history + actual taken
                current_history <= {train_history[30:0], train_taken};
                speculative_history <= {train_history[30:0], train_taken};
            end else begin
                // Normal operation
                if (predict_valid) begin
                    speculative_history <= {speculative_history[30:0], predict_taken};
                end
                // Current history tracks committed branches
                current_history <= speculative_history;
            end
        end
    end

endmodule