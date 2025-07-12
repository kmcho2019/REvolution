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

    assign predict_history = speculative_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            committed_history <= 32'b0;
            speculative_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Atomic update of both histories on misprediction
            committed_history <= {train_history[30:0], train_taken};
            speculative_history <= {train_history[30:0], train_taken};
        end else begin
            // Normal operation - only update speculative history
            if (predict_valid) begin
                speculative_history <= {speculative_history[30:0], predict_taken};
            end
            // committed_history remains stable
        end
    end

endmodule