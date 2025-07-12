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

    reg [31:0] committed_history;
    reg [31:0] speculative_history;
    reg has_speculative_update;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            committed_history <= 32'b0;
            speculative_history <= 32'b0;
            has_speculative_update <= 1'b0;
        end else if (train_mispredicted) begin
            // Rollback: load correct history and clear any speculation
            committed_history <= {train_history[30:0], train_taken};
            has_speculative_update <= 1'b0;
        end else if (has_speculative_update) begin
            // Commit previous speculative update
            committed_history <= speculative_history;
            has_speculative_update <= 1'b0;
            
            // Handle new prediction in same cycle if present
            if (predict_valid) begin
                speculative_history <= {committed_history[30:0], predict_taken};
                has_speculative_update <= 1'b1;
            end
        end else if (predict_valid) begin
            // New prediction - store speculative update
            speculative_history <= {committed_history[30:0], predict_taken};
            has_speculative_update <= 1'b1;
        end
    end

    assign predict_history = committed_history;

endmodule